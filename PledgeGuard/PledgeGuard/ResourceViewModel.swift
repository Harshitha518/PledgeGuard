//
//  ResourceViewModel.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 4/25/25.
//

import Foundation
import FirebaseFirestore

class ResourceViewModel: ObservableObject {
    @Published var resources: [Resource] = []
    
    func fetchResources() {
        let db = Firestore.firestore()
        db.collection("resources").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
            }
            else {
                self.resources = snapshot?.documents.compactMap { doc -> Resource? in
                    let data = doc.data()
                    let category = data["category"] as? String ?? ""
                    let contentURL = data["contentURL"] as? String ?? ""
                    let region = data["region"] as? String ?? ""
                    let title = data["title"] as? String ?? ""
                    
                    return Resource(
                        category: category,
                        contentURL: contentURL,
                        region: region,
                        title: title
                    )
                } ?? []
                
            }
        }

    }
}
