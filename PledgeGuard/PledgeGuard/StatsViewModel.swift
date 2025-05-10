//
//  StatsViewModel.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 4/28/25.
//

import Foundation
import FirebaseFirestore
import CoreLocation

class StatsViewModel : ObservableObject {
    
    func getPledgesCount(completion: @escaping (Int) -> Void) {
        let db = Firestore.firestore()

        db.collection("users").count.getAggregation(source: .server) { snapshot, error in
            if let error = error {
                print("Error getting pledge count: \(error)")
                completion(0)
                return
            }

            if let count = snapshot?.count {
                completion(Int(truncating: count))
            } else {
                completion(0)
            }
        }
    }
    
    func getReportsCount(completion: @escaping (Int) -> Void) {
        let db = Firestore.firestore()

        db.collection("reports").count.getAggregation(source: .server) { snapshot, error in
            if let error = error {
                print("Error getting report count: \(error)")
                completion(0)
                return
            }

            if let count = snapshot?.count {
                completion(Int(truncating: count))
            } else {
                completion(0)
            }
        }
    }
    
    func getResolvedReportsCount(completion: @escaping (Int) -> Void) {
        let db = Firestore.firestore()
        
        let resolvedQuery = db.collection("reports").whereField("resolved", isEqualTo: true)
        
        resolvedQuery.count.getAggregation(source: .server) { snapshot, error in
            if let error = error {
                print("Error getting resolved report count: \(error)")
                completion(0)
                return
            }

            if let count = snapshot?.count {
                completion(Int(truncating: count))
            } else {
                completion(0)
            }
        }
    }

    func getActionsCount(completion: @escaping (Int) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("actions").count.getAggregation(source: .server) { snapshot, error in
            if let error = error {
                print("Error getting action count: \(error)")
                completion(0)
                return
            }
            
            if let count = snapshot?.count {
                completion(Int(truncating: count))
            } else {
                completion(0)
            }
        }
    }
    
    func getReportsUrgrencyLevel(completion: @escaping (Double, Double, Double) -> Void) {
        let db = Firestore.firestore()

        let highQuery = db.collection("reports").whereField("urgencyLevel", isEqualTo: "High")
        let moderateQuery = db.collection("reports").whereField("urgencyLevel", isEqualTo: "Moderate")
        let lowQuery = db.collection("reports").whereField("urgencyLevel", isEqualTo: "Low")
        
        var highCount = 0
        var moderateCount = 0
        var lowCount = 0

        let group = DispatchGroup()
        
        group.enter()
        highQuery.count.getAggregation(source: .server) { snapshot, error in
            if let count = snapshot?.count {
                highCount = Int(truncating: count)
            }
            group.leave()
        }
        
        group.enter()
        moderateQuery.count.getAggregation(source: .server) { snapshot, error in
            if let count = snapshot?.count {
                moderateCount = Int(truncating: count)
            }
            group.leave()
        }

        group.enter()
        lowQuery.count.getAggregation(source: .server) { snapshot, error in
            if let count = snapshot?.count {
                lowCount = Int(truncating: count)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            let total = highCount + moderateCount + lowCount
            guard total > 0 else {
                completion(0, 0, 0)
                return
            }
            
            
            let highPercentage = round(Double(highCount) / Double(total) * 100)
            let moderatePercentage = round(Double(moderateCount) / Double(total) * 100)
            let lowPercentage = round(Double(lowCount) / Double(total) * 100)
            
            completion(highPercentage, moderatePercentage, lowPercentage)
            
        }

    }
    
    func getReportsRegions(completion: @escaping ([String: Int]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("reports").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting information: \(error)")
                completion([:])
                return
            }
            
            if let snapshot = snapshot {
                var reportsByRegion: [String: Int] = [:]
                
                let dispatchGroup = DispatchGroup()
                            
                for document in snapshot.documents {
                    dispatchGroup.enter()
                    
                    let geoPoint: GeoPoint = document["location"] as! GeoPoint
                    self.reverseGeocodeLocation(geoPoint: geoPoint) { address in
                        if let address = address {
                            let region = address.components(separatedBy: ", ").last ?? "Unknown region"
                            reportsByRegion[region, default: 0] += 1

                        } else {
                            print("Could not reverse geocode the location.")
                        }
                        
                        dispatchGroup.leave()
                        
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    completion(reportsByRegion)
                }
            }
        }
    }
    

    func reverseGeocodeLocation(geoPoint: GeoPoint, completion: @escaping (String?) -> Void) {

        let location = CLLocation(latitude: geoPoint.latitude, longitude: geoPoint.longitude)

    
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error geocoding location: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let placemark = placemarks?.first {
                
                let address = [
                    placemark.locality ?? "Unknown city",
                    placemark.administrativeArea ?? "Unknown state",
                    placemark.country ?? "Unknown country"
                ].joined(separator: ", ")

                completion(address)
            } else {
                print("No placemarks found")
                completion(nil)
            }
        }
    }
}
