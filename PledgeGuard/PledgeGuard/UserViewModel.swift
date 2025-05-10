//
//  UserViewModel.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 5/3/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class UserViewModel: ObservableObject {
    let uid = Auth.auth().currentUser?.uid
    
    @Published var user: User?
    
    
    @Published var reportCount: Int = 0
    @Published var actionCount: Int = 0
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user is logged in.")
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
                
            guard let data = snapshot?.data() else { return }
            
            let timestamp = data["dateJoined"] as? Timestamp


            let userData = User(
                userId: data["userId"] as? String ?? "",
                dateJoined: timestamp?.dateValue() ?? Date(),
                fullName: data["fullName"] as? String ?? "",
                pledgeText: data["pledgeText"] as? String ?? "",
                role: data["role"] as? String ?? "",
                actionCount: data["actionCount"] as? Int ?? 0,
                reportCount: data["reportCount"] as? Int ?? 0
            )
            
            print(userData.dateJoined)

            DispatchQueue.main.async {
                self.user = userData
                self.actionCount = data["actionCount"] as? Int ?? 0
                self.reportCount = data["reportCount"] as? Int ?? 0
            }
            

            
        }
    }
    
}
