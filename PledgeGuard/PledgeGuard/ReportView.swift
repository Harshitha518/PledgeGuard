//
//  ReportView.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 4/25/25.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore
import MapKit
import FirebaseAuth

struct ReportView: View {
    @State private var report = Report(id: "", description: "", location: nil, address: nil, time: Date(), urgencyLevel: "Low", userId: "", flagged: 0, addressed: 0, resolved: false)
    @ObservedObject var viewModel = SearchLocationViewModel()
    @State private var description: String = ""
    @State private var urgencyLevel: String = "Low"
    @State private var selectedSuggestion: MKLocalSearchCompletion?
    @State private var position = MapCameraPosition.automatic

    
    var geoPoint: GeoPoint? {
        viewModel.selectedCoordinate.map { GeoPoint(latitude: $0.latitude, longitude: $0.longitude) }
    }
    
    @EnvironmentObject var selectedTab: TabManager
    @Binding var path: NavigationPath

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("PledgeGuard")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.accent)
                        Spacer()
                        NavigationLink {
                            PledgerView()
                        } label: {
                            Image(systemName: "questionmark.circle.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundStyle(.alert)
                                .padding(.trailing)
                        }

                    }

                    Text("Report A Concern")
                        .font(.title2)
                        .foregroundColor(.alert)

                    Divider()

                        
                        Text("Description")
                        TextEditor(text: $description)
                            .frame(height: 100)
                            .foregroundStyle(Color.text)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                        
                        Text("Urgency Level")
                            .foregroundStyle(Color.text)
                        Picker("Urgency", selection: $urgencyLevel) {
                            Text("Low").tag("Low")
                            Text("Moderate").tag("Moderate")
                            Text("High").tag("High")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Text("Location")
                            .foregroundStyle(Color.text)
                        TextField("Search for the location", text: $viewModel.searchQuery)
                            .onChange(of: viewModel.searchQuery) {
                                viewModel.updateQuery()
                            }
                        ScrollView {
                        VStack(spacing: 8) {
                            ForEach(viewModel.suggestions, id: \.self) { suggestion in
                                Button {
                                    viewModel.selectSuggestion(suggestion)
                                    selectedSuggestion = suggestion
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        if let coordinate = viewModel.selectedCoordinate {
                                            position = .region(MKCoordinateRegion(
                                                center: coordinate,
                                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                            ))
                                        }
                                    }
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Divider()
                                            Text(suggestion.title)
                                                .bold()
                                                .foregroundStyle(Color.text)
                                                .padding()
                                        }
                                        Spacer()
                                        if selectedSuggestion == suggestion {
                                            Image(systemName: "checkmark.circle")
                                                .foregroundStyle(Color.accent)
                                                .padding()
                                        }
                                    }
                                }
                            }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .border(Color.accent, width: 2)
                        .overlay {
                            VStack {
                                    Spacer()
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.clear, Color.bg]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    .frame(height: 50)
                                }
                        }

                        Map(position: $position) {
                            if let coordinate = viewModel.selectedCoordinate {
                                Marker("Location Of Incident", systemImage: "exclamationmark.bubble.fill", coordinate: coordinate)
                            }
                        }
                        .frame(height: 200)
                        .cornerRadius(10)
                        
                        Button("Submit Report") {
                            uploadReport()
                            description = ""
                            urgencyLevel = "Low"
                            selectedSuggestion = nil
                            position = MapCameraPosition.automatic
                            
                            viewModel.selectedCoordinate = nil
                            viewModel.searchQuery = ""
                            viewModel.selectedAddress = nil
                            viewModel.suggestions.removeAll()
                            
                            selectedTab.selectedTab = 1
                            path = NavigationPath()
                        }
                        .frame(width: 400, height: 40)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(Color.bg)
                        .cornerRadius(10)
                        .disabled(geoPoint == nil)
                    }
                    .padding()
            }
            .background {
                Color.bg.edgesIgnoringSafeArea(.all)
            }
        }
      
    }
    
    func uploadReport() {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid ?? ""
        
        var reportData: [String: Any] = [
            "description": description,
            "time": Date(),
            "urgencyLevel": urgencyLevel,
            "userId": userId,
            "flagged": 0,
            "addressed": 0,
            "resolved": false
        ]
        
        if let coordinate = viewModel.selectedCoordinate {
            reportData["location"] = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        
        if let address = viewModel.selectedAddress {
            reportData["address"] = address
        }


        db.collection("reports").addDocument(data: reportData) { error in
            if let error = error {
                print("Error uploading report: \(error)")
            } else {
                print("Report submitted successfully!")
            }
        }
        
        
        let userRef = db.collection("users").document(userId)
        userRef.updateData([
            "reportCount": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("Error updating report count: \(error.localizedDescription)")
            } else {
                print("Report count updated successfully!")
            }
        }
        
        let userRef2 = db.collection("users").document(userId)
        userRef.updateData([
            "actionCount": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("Error updating action count: \(error.localizedDescription)")
            } else {
                print("Action count updated successfully!")
            }
        }


        
        
    }
}

class SearchLocationViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchQuery = ""
    @Published var suggestions: [MKLocalSearchCompletion] = []
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var selectedAddress: String? = nil

    private var searchCompleter: MKLocalSearchCompleter

    override init() {
        self.searchCompleter = MKLocalSearchCompleter()
        super.init()
        self.searchCompleter.delegate = self
        self.searchCompleter.resultTypes = [.address, .pointOfInterest]
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.suggestions = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search failed: \(error.localizedDescription)")
    }
    
    func selectSuggestion(_ suggestion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestion)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] response, error in
            guard let mapItem = response?.mapItems.first else { return }
            self?.selectedCoordinate = mapItem.placemark.coordinate
            self?.selectedAddress = mapItem.placemark.title
        }
    }

    func updateQuery() {
        self.searchCompleter.queryFragment = searchQuery
    }
}
