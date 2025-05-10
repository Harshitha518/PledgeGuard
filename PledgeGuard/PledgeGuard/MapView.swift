//
//  MapView.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 4/26/25.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore
import MapKit
import FirebaseAuth
struct MapView: View {
    @State private var position = MapCameraPosition.automatic
    @ObservedObject var viewModel: ReportViewModel
    @ObservedObject var statsVM: StatsViewModel = StatsViewModel()
    
    @State private var pledgeCount = 0
    @State private var reportCount = 0
    @State private var resolvedCount = 0
    @State private var actionCount = 0
    
    @State private var urgencyLevels: (Int, Int, Int) = (0, 0, 0)
    
    @State private var regionalData = [String: Int]()
    
    var validReports: [Report] {
        viewModel.reports.filter { $0.location != nil }
    }
    
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


                    Text("Statistics")
                        .font(.title2)
                        .foregroundColor(.alert)

                    Divider()
                        
                    Text("Map")
                            .font(.headline)
                            .foregroundStyle(.text)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    Map(position: $position) {
                        ForEach(validReports, id: \.self) { report in
                            let geoPoint = report.location!
                            let coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                            
                            Marker(
                                report.address ?? "Unknown Location",
                                systemImage: "exclamationmark.bubble.fill",
                                coordinate: coordinate
                            )
                        }
                    }
                    .frame(height: 600)
                    .cornerRadius(10)
                    .onAppear {
                        updateCameraPosition()
                    }
                    .onChange(of: viewModel.reports) {
                        updateCameraPosition()
                    }
                    .padding(.bottom)
                    .padding(.horizontal)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.bg)
                            .frame(width: 410, height: 600)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.clear)
                                    .stroke(Color.accentColor, lineWidth: 2)
                            }

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Insights")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            
                            Text("Over **\(pledgeCount)** people pledged to stand against child marriage.")
                                .font(.body)
                                .padding(.bottom, 4)
                            
                            Text("**\(reportCount)** potential child marriage risks reported.")
                                .font(.body)
                                .padding(.bottom, 4)
                            
                            Text("**\(resolvedCount)** children rescued from child marriage.")
                                .font(.body)
                                .padding(.bottom, 4)
                            
                            Text("**\(actionCount)** actions taken agaisnt child marriage.")
                            
                            VStack(alignment: .leading) {
                                Text("**\(urgencyLevels.0)%** high urgency")
                                Text("**\(urgencyLevels.1)%** moderate urgency")
                                Text("**\(urgencyLevels.2)%** low urgency")
                            }
                            .font(.body)
                            .padding(.bottom, 16)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "mappin.circle")
                                    
                                    Text("Reports by Region")
                                        .font(.headline)
                                        .padding(.bottom, 8)
                                }
                                
                                
                                ForEach(regionalData.sorted(by: { $0.key < $1.key }), id: \.key) { region, count in
                                    HStack {
                                        Text("\(region):")
                                            .font(.body)
                                            .fontWeight(.semibold)
                                        Text("\(count) report\(count == 1 ? "" : "s")")
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                HStack {
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                    }
                    .shadow(radius: 5)
                    .onAppear {
                        print("Valid Reports: \(validReports)")
                        
                        statsVM.getPledgesCount(completion: { count in
                            pledgeCount = count
                        })
                        statsVM.getReportsCount(completion: { count in
                            reportCount = count
                        })
                        statsVM.getResolvedReportsCount { count in
                            resolvedCount = count
                        }
                        statsVM.getActionsCount { count in
                            actionCount = count
                        }
                        statsVM.getReportsUrgrencyLevel(completion: { high, moderate, low  in
                            urgencyLevels.0 = Int(high)
                            urgencyLevels.1 = Int(moderate)
                            urgencyLevels.2 = Int(low)
                        })
                        statsVM.getReportsRegions { regions in
                            regionalData = regions
                        }

                        
                    }
                    .padding(.horizontal)
                    
            
            }
            .background {
                Color.bg.edgesIgnoringSafeArea(.all)
            }
          
        }
    }
    
    private func updateCameraPosition() {
        guard !validReports.isEmpty else {
            return
        }
        
        var minLat = validReports.first!.location!.latitude
        var maxLat = validReports.first!.location!.latitude
        var minLon = validReports.first!.location!.longitude
        var maxLon = validReports.first!.location!.longitude
        
        
        for report in validReports {
            guard let geoPoint = report.location else { continue }
            
            minLat = min(minLat, geoPoint.latitude)
            maxLat = max(maxLat, geoPoint.latitude)
            minLon = min(minLon, geoPoint.longitude)
            maxLon = max(maxLon, geoPoint.longitude)
        }
        
       
        let centerCoordinate = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        
  
        let latDelta = maxLat - minLat
        let lonDelta = maxLon - minLon
        let span = MKCoordinateSpan(latitudeDelta: latDelta * 1.2, longitudeDelta: lonDelta * 1.2) 
        
       
        position = .region(MKCoordinateRegion(center: centerCoordinate, span: span))
    }
}


#Preview {
    MapView(viewModel: ReportViewModel())
}
