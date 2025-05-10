//
//  ActionView.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 5/6/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ActionView: View {    
    @State private var selectedAction: String? = nil
    
    var actions = [
        "Awareness-Based Actions":
            ["Spoke Up About Child Marriage", "Shared a Story", "Posted Online", "Translated Information About Child Marriage"],
        "Social / Peer Support Actions":
            ["Checked In on Someone at Risk", "Listened Without Judging", "Referred to Help", "Offered a Safe Space"],
        "Community Action":
            ["Started a Conversation at School / Work", "Organized a Group Pledge", "Contacted a Local Official or Organization", "Distributed Flyers / Posters"],
        "PledgeGuard Specific Actions":
            [ "Reviewed Roles and Responsibilities as a Pledger", "Reviewed Resources Provided to Pledgers", "Reviewed PledgeGuard's Mission"]
    ]
    
    @State private var type = "Spoke Up About Child Marriage"
    @State private var selectedCategory = "Awareness-Based Actions"
    
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("PledgeGuard")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.accent)
                        Text("Take Action")
                            .font(.title2)
                            .foregroundColor(.alert)
                        
                        Divider()
                        
                        Text("Make sure to log in any actions you take, no matter how big or small here. This will help us track your progress and ensure that you are making a difference. Select the circle by the action once to log your action.")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.vertical)
                        
                        ForEach(Array(actions.keys), id: \.self) { category in
                            DisclosureGroup {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(actions[category] ?? [], id: \.self) { action in
                                        HStack {
                                            Button {
                                                selectedCategory = category
                                                type = action
                                                uploadAction()
                                                if selectedAction == action {
                                                    selectedAction = nil
                                                } else {
                                                    selectedAction = action
                                                }
                                            } label: {
                                                Image(systemName: selectedAction == action ? "checkmark.circle.fill" : "circle")
                                                            .imageScale(.large)
                                                            .foregroundStyle(.text)
                                            }
                                            
                                            Text(action)
                                                    .foregroundStyle(.text)
                                            
                                            Spacer()
                                        }
                                        .padding(.vertical)
                                        .foregroundStyle(.text)
                                        .font(.subheadline)
                                    }
                                }
                            } label: {
                                Text(category)
                            }
                            .accentColor(.bg)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.accentColor)
                            )
                            .font(.headline)
                            
                        }
                    }
                }
                
                .padding(.horizontal)
                
            }
            .background {
                Color.bg.edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    func uploadAction() {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid ?? ""
        
        let actionData: [String: Any] = [
            "userId": userId,
            "type": type,
            "category": selectedCategory,
            "time": Date(),
            "notes": notes
        ]
        
        let userRef = db.collection("users").document(userId)
        userRef.updateData([
            "actionCount": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("Error updating action count: \(error.localizedDescription)")
            } else {
                print("Action count updated successfully!")
            }
        }
        
        
        db.collection("actions").addDocument(data: actionData) { error in
            if let error = error {
                print("Error uploading action: \(error)")
            } else {
                print("Action submitted successfully!")
            }
        }
    }
    
}

