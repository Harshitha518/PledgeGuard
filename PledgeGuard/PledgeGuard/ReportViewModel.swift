import Foundation
import FirebaseFirestore

class ReportViewModel: ObservableObject {
    @Published var reports: [Report] = []
    
    private var isAppLaunchedBefore = false

    
    func startListeningForReports() {
      
        let db = Firestore.firestore()
        
        
        
        db.collection("reports").addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            
            for diff in snapshot.documentChanges {
                let data = diff.document.data()
                let id = diff.document.documentID

                switch diff.type {
                case .added:
                    guard let description = data["description"] as? String,
                          let time = (data["time"] as? Timestamp)?.dateValue(),
                          let urgencyLevel = data["urgencyLevel"] as? String,
                          let userId = data["userId"] as? String else {
                        return
                    }
                    let location = data["location"] as? GeoPoint
                    let address = data["address"] as? String
                    let flagged = data["flagged"] as? Int ?? 0
                    let addressed = data["addressed"] as? Int ?? 0
                    let resolved = data["resolved"] as? Bool ?? false

                    let report = Report(
                        id: id,
                        description: description,
                        location: location,
                        address: address,
                        time: time,
                        urgencyLevel: urgencyLevel,
                        userId: userId,
                        flagged: flagged,
                        addressed: addressed,
                        resolved: resolved
                    )

                    DispatchQueue.main.async {
                        self.reports.append(report)
                        self.reports.sort { $0.time > $1.time }

                        if !self.isAppLaunchedBefore {
                            self.isAppLaunchedBefore = true
                        } else {
                            NotificationManager.shared.sendLocalNotification(
                                title: NSLocalizedString("report_received", comment: ""),
                                body: (address != nil)
                                    ? String(format: NSLocalizedString("report_body_with_address", comment: ""), urgencyLevel.lowercased(), address!)
                                    : String(format: NSLocalizedString("report_body_without_address", comment: ""), urgencyLevel.lowercased())
                            )
                        }
                    }

                case .modified:
                    if let index = self.reports.firstIndex(where: { $0.id == id }) {
                        let updatedReport = Report(
                            id: id,
                            description: data["description"] as? String ?? "",
                            location: data["location"] as? GeoPoint,
                            address: data["address"] as? String,
                            time: (data["time"] as? Timestamp)?.dateValue() ?? Date(),
                            urgencyLevel: data["urgencyLevel"] as? String ?? "",
                            userId: data["userId"] as? String ?? "",
                            flagged: data["flagged"] as? Int ?? 0,
                            addressed: data["addressed"] as? Int ?? 0,
                            resolved: data["resolved"] as? Bool ?? false
                        )

                        DispatchQueue.main.async {
                            self.reports[index] = updatedReport
                        }
                    }

                case .removed:
                    self.reports.removeAll { $0.id == id }

                default:
                    break
                }
            }

        }
    }
}
