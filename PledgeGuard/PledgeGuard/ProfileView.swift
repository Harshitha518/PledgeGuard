//
//  ProfileView.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 5/3/25.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: UserViewModel
    
    @EnvironmentObject var selectedTab: TabManager
    @Binding var path: NavigationPath
    
    @AppStorage("firstTime") var firstTime: Bool = true

    
    var pledgeText = "I pledge to stand against child marriage by reporting suspected cases, refusing harmful practices, raising awareness, supporting survivors, and encouraging others to take action."
    
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

                        Text(firstTime ? "Welcome \(viewModel.user?.fullName ?? "")" : "Welcome Back, \(viewModel.user?.fullName ?? "")")
                            .font(.title2)
                            .foregroundColor(.alert)

                        Divider()
                        
                        PledgeBlockView(pledge: pledgeText, viewModel: viewModel)
                        
                        NavigationLink {
                            PledgerView()
                        } label: {
                            Text("> Your Responsibility As A Pledger")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.alert)
                            
                        }

                        
                        Text("Your Activity")
                                .font(.headline)
                            
                        Text("Joined \(viewModel.user?.dateJoined.formatted(date: .complete, time: .omitted) ?? Date().formatted(date: .complete, time: .omitted))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            
                        HStack {
                            VStack {
                                StatBox(label: "Reports", value: "\(viewModel.reportCount)")
                                Text("Count of reports submitted \n")                     .font(.caption)
                                    .foregroundStyle(.accent)
                            }
                            
                            VStack {
                                StatBox(label: "Actions", value: "\(viewModel.actionCount)")
                                Text("Count of actions taken (eg. report, take pledge, view resource, etc)")                     .font(.caption)
                                    .foregroundStyle(.accent)
                            }
                        }

                        
                        Text("Explore")
                            .font(.headline)
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Button {
                                selectedTab.selectedTab = 0
                                path = NavigationPath()
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accent)
                                    .frame(width: 430, height: 50)
                                    .overlay(
                                        Text("REPORT")
                                            .foregroundStyle(.bg)
                                            .font(.title3)
                                            .bold()
                                    )
                            }
                            .shadow(color: .alert, radius: 5)
                            
                            NavigationLink {
                                MissionView()
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accent)
                                    .frame(width: 430, height: 50)
                                    .overlay(
                                        Text("Our Mission")
                                            .foregroundStyle(.bg)
                                            .font(.title3)
                                    )
                            }
                            
                            
                            NavigationLink {
                                ActionView()
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accent)
                                    .frame(width: 430, height: 50)
                                    .overlay(
                                        Text("Take Action")
                                            .foregroundStyle(.bg)
                                            .font(.title3)
                                    )
                            }

                        }
                     
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
            }
            .background {
                Color.bg.edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            viewModel.fetchUser()
        }
        .onDisappear {
            firstTime = false
        }

    }
}

struct StatBox: View {
    var label: String
    var value: String

    var body: some View {
        VStack {
            Text(value)
                .font(.title)
                .bold()
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PledgeBlockView: View {
    var pledge: String
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.bg)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accent, lineWidth: 2)
                )
                .shadow(radius: 5)

            
            VStack(alignment: .leading, spacing: 8) {
                Text(pledge)
                    .font(.subheadline)
                    .foregroundStyle(.text)
                   
                NavigationLink {
                    FullPledgeView(viewModel: viewModel)
                } label: {
                    Text("> View Full Pledge")
                        .font(.caption)
                        .foregroundStyle(.alert)
                }


                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    func timeAgoString(date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        
        if let years = components.year, years > 0 {
            return "\(years) year\(years == 1 ? "" : "s") ago"
        } else if let months = components.month, months > 0 {
            return "\(months) month\(months == 1 ? "" : "s") ago"
        } else if let days = components.day, days > 0 {
            return "\(days) day\(days == 1 ? "" : "s") ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }

    
}
