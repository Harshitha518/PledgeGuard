//
//  ContentView.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 4/24/25.
//


/*
 PledgeGuard is a Swift-based mobile app designed to combat child marriage and protect at-risk girls through community accountability. Users can report suspected cases, receive local alerts, and pledge actionable support—like checking in on someone, spreading awareness, or sharing resources. The app transforms bystanders into protectors by enabling them to actively prevent harmful practices and connect others to legal, emotional, and safety support. It’s a tool for early intervention and community-led advocacy rooted in the goals of SDG 5 and SDG 10.

 PledgeGuard isn’t just an app. It’s a growing movement of protectors, students, teachers, parents, standing up for girls’ safety. Every alert, every pledge, every action is a step toward prevention. It is not only scalable and secure, but also human.
 */


import SwiftUI
import CoreLocation
import FirebaseFirestore
import MapKit
import FirebaseAuth


struct PledgeView: View {
    @ObservedObject var viewModel: UserViewModel
    
    @State var user: User?

    @Environment(\.dismiss) var dismiss
    
    @State private var nameSign = ""
    @State private var role = "Concerned Citizen"
    
    let pledgeText = "I pledge to take action to protect at-risk girls and stand against child marriage. I commit to: \n\n1.   Reporting suspected cases on PledgeGuard (or straight to authorities depending on urgency) to help prevent child marriage in my community. \n\n2.   Never participate in any  practices that promote child marriage. \n\n3.   Raising awareness and educating others about the dangers of child marriage. \n\n4.   Supporting survivors and at-risk girls by connecting them with resources, legal help, and emotional support. \n\n5.   Encouraging others to join the movement and take action in the fight for gender equality and safety for all."
    let roles = ["Concerned Citizen", "Youth Leader", "Educator", "Parent or Guardian", "Social Worker", "Legal Advocate", "Healthcare Provider", "NGO Volunteer", "Online Advocate", "Diaspora Ally"]
    
    var body: some View {
        NavigationStack {
            VStack {
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

                    Text("Take the Pledge")
                        .font(.title2)
                        .foregroundColor(.alert)
                    
                    Divider()
                        
                    Text(String(format: NSLocalizedString("pledge_text", comment: "")))
                        .padding(.bottom, 5)
                    
                    
                }
                .padding(.bottom)
                .foregroundStyle(.text)
                
                HStack {
                    Text("Select The Role That Fits You Best:   ")
                        .font(.headline)
                        .foregroundStyle(.text)
                    
                    Picker("Select Your Role", selection: $role) {
                        ForEach(roles, id: \.self) { role in
                            Text(role)
                                .foregroundStyle(.alert)
                        }
                    }
                    .pickerStyle(.automatic)
                }
                
                Spacer()
                
                Text("Sign here:")
                    .font(.headline)
                    .foregroundStyle(.text)
                TextField("Enter your full name...", text: $nameSign)
                    .padding()
                    .frame(width: 300, height: 50)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.text, lineWidth: 2))
                
                
                Spacer()
                
                
                Button {
                    signPledge()
                    dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accent)
                        .frame(width: 300, height: 50)
                        .overlay(
                            Text("Sign The Pledge")
                                .foregroundStyle(.text)
                        )
                }
                .disabled(nameSign.isEmpty)

                
                                
                Spacer()
            }
            .padding()
            .background {
                Color.bg.edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    func signPledge() {
        guard let uid = Auth.auth().currentUser?.uid else {
                print("Error: No user is signed in.")
                return
            }

        let db = Firestore.firestore()
      
        db.collection("users").document(uid).setData([
            "userId": uid,
            "dateJoined": Date(),
            "fullName": nameSign,
            "pledgeText": pledgeText,
            "role": role,
            "actionCount": 1,
            "reportCount": 0
        ]) { error in
            if let error = error {
                print("Error writing user to Firestore: \(error)")
            } else {
                viewModel.fetchUser()
                user = viewModel.user
                print("User signed pledge successfully!")
            }
        }
        
    
    }
    
}

