
//
//  FullAlertView.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 5/8/25.
//

import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseAuth

struct FullAlertView: View {
    @ObservedObject var userVM: UserViewModel
    @ObservedObject var reportVM: ReportViewModel
    
    @Binding var report: Report
    
    @State private var position = MapCameraPosition.automatic
    
    @State private var flaggedInfo = false
    @State private var addressedInfo = false
    @State private var resolvedInfo = false
    
    @State private var userFlagged = false
    @State private var userAddressed = false
    @State private var userResolved = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("PledgeGuard")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.accent)
                        Text(report.address ?? "Alert!")
                            .font(.title2)
                            .foregroundColor(.alert)
                        
                        Divider()
                        
                        HStack {
                            Text("Urgency Level:   ")
                                .font(.title3)
                                .foregroundStyle(.text)
                            Text(report.urgencyLevel)
                                .font(.title3)
                                .foregroundStyle(report.urgencyLevel == "High" ? .alert : .alert.opacity(0.5))
                                .bold(report.urgencyLevel == "low" ? false : true)
                            Spacer()
                        }
                        
                                
                        HStack {
                            Text("Time of report submission:   ")
                                .font(.caption)
                                .foregroundColor(.text)
                            Text("\(report.time)")
                                .font(.caption)
                                .foregroundColor(.accentColor)
                            Spacer()

                        }
                        .padding(.bottom)
                        
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Report was flagged **\(report.flagged)** times")
                            Text("Report was addressed by **\(report.addressed)** times")
                            Text(userResolved ? "Report was resolved" : "Report has not been resolved yet")
                                .bold()
                        }
                        .foregroundStyle(.text)
                        .font(.subheadline)
                        

                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.bg)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.accent, lineWidth: 2)
                                )

                            
                            Text("**Description:** \(report.description)")
                                .font(.subheadline)
                                .lineLimit(nil)
                                .foregroundColor(.text)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        
                        Map(position: $position) {
                            let geoPoint = report.location!
                            let coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                                
                            Marker(
                                report.address ?? "Unknown Location",
                                systemImage: "exclamationmark.bubble.fill",
                                coordinate: coordinate
                            )
                            
                        }
                        .frame(height: 300)
                        .cornerRadius(10)
                        
                        
                        Text("Actions: ")
                            .foregroundStyle(.accent)
                            .font(.title3)
                            .bold()
                        
                        HStack {
                            VStack {
                                Button {
                                    flagReport()
                                    userFlagged = true
                                } label: {
                            
                                        Image(systemName: userFlagged ? "flag.fill" : "flag")
                                            .foregroundStyle(userFlagged ? .alert : .text)
                                            .font(.largeTitle)
                                    
                                }
                                
                                
                                Button {
                                        flaggedInfo = true
                                } label: {
                                        HStack {
                                            Text("Flag report")
                                            Image(systemName: "questionmark.circle")
                                        }
                                        .font(.headline)
                                        .foregroundStyle(.accent)
                                }
                                .alert(isPresented: $flaggedInfo) {
                                    Alert(title: Text("Flag Report"), message: Text("Tap to log if you believe this report is untrustworthy."), dismissButton: .default(Text("OK")))
                                }

                            }
                            
                            Spacer()
                            
                            VStack {
                                Button {
                                    addressReport()
                                    userAddressed = true
                                } label: {
                                    Image(systemName: userAddressed ? "checkmark.circle.fill" : "checkmark.circle")
                                        .foregroundStyle(userAddressed ? .green : .text)
                                        .font(.largeTitle)
                                }
                                Button {
                                        addressedInfo = true
                                } label: {
                                        HStack {
                                            Text("Address report")
                                            Image(systemName: "questionmark.circle")
                                        }
                                        .font(.headline)
                                        .foregroundStyle(.accent)
                                }
                                .alert(isPresented: $addressedInfo) {
                                    Alert(title: Text("Address Report"), message: Text("Tap to log if you have taken action to address this specific report."), dismissButton: .default(Text("OK")))
                                }
                            }
                            Spacer()
                            
                            VStack {
                                Button {
                                    resolveReport()
                                    userResolved = true
                                } label: {
                                   
                                    Image(systemName: userResolved ? "shield.lefthalf.filled.badge.checkmark" :"shield.lefthalf.filled")
                                        .foregroundStyle(userResolved ? .accent : .text)
                                        .font(.largeTitle)
                                        .disabled(userResolved)
                                    
                                }
                                
                                Button {
                                        resolvedInfo = true
                                } label: {
                                        HStack {
                                            Text("Resolve report")
                                            Image(systemName: "questionmark.circle")
                                        }
                                        .font(.headline)
                                        .foregroundStyle(.accent)
                                }
                                .alert(isPresented: $resolvedInfo) {
                                    Alert(title: Text("Resolve Report"), message: Text("The report can only be resolved once. Any user can resolve a report to indicate the conflict has been addressed and all involved parties are safe."), dismissButton: .default(Text("OK")))
                                }

                            }


                        }
                        .padding(.bottom)
                    
                    }
                    .background {
                        Color.bg.edgesIgnoringSafeArea(.all)
                    }
                
                }
                .padding(.horizontal)
            }
           
            .onAppear {
                userResolved = report.resolved
            }
        }
    }
    
    private func flagReport() {
        let userId = Auth.auth().currentUser?.uid ?? ""
        
        let reportRef = Firestore.firestore().collection("reports").document(report.id)
        let userRef = Firestore.firestore().collection("users").document(userId)
        
        let batch = Firestore.firestore().batch()
        
        batch.updateData(["flagged": FieldValue.increment(Int64(1))], forDocument: reportRef)
        batch.updateData(["actionCount": FieldValue.increment(Int64(1))], forDocument: userRef)


        batch.commit { error in
            if let error = error {
                print("Failed to flag report: \(error.localizedDescription)")
            } else {
                print("Report flagged successfully!")
            }
        }

        
    }
    
    private func addressReport() {
        let userId = Auth.auth().currentUser?.uid ?? ""
        
        let reportRef = Firestore.firestore().collection("reports").document(report.id)
        let userRef = Firestore.firestore().collection("users").document(userId)
        
        let batch = Firestore.firestore().batch()
        
        batch.updateData(["addressed": FieldValue.increment(Int64(1))], forDocument: reportRef)
        batch.updateData(["actionCount": FieldValue.increment(Int64(1))], forDocument: userRef)


        batch.commit { error in
            if let error = error {
                print("Failed to address report: \(error.localizedDescription)")
            } else {
                print("Report addressed successfully!")
            }
        }

    }
    
    private func resolveReport() {
        let userId = Auth.auth().currentUser?.uid ?? ""
        
        let reportRef = Firestore.firestore().collection("reports").document(report.id)
            let userRef = Firestore.firestore().collection("users").document(userId)

            let batch = Firestore.firestore().batch()

            batch.updateData(["resolved": true], forDocument: reportRef)
            
            batch.updateData(["actionCount": FieldValue.increment(Int64(1))], forDocument: userRef)

            batch.commit { error in
                if let error = error {
                    print("Failed to resolve report: \(error.localizedDescription)")
                } else {
                    print("Report resolved successfully!")
                }
            }
        }

}
