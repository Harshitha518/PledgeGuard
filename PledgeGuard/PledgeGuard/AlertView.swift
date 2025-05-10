//
//  AlertView.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 4/25/25.
//

import SwiftUI
import FirebaseFirestore

struct AlertView: View {
    @ObservedObject var viewModel: ReportViewModel
    @ObservedObject var userVM: UserViewModel
    
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


                    Text("Recent Alerts")
                        .font(.title2)
                        .foregroundColor(.alert)

                    Divider()
                        
                        if !viewModel.reports.filter({ !$0.resolved }).isEmpty {
                            Text("Unresolved Reports")
                                .font(.headline)
                                .foregroundStyle(.text)
                                        
                            ForEach(Array(viewModel.reports.enumerated()), id: \.element.id) { index, report in
                                if !report.resolved {
                                    NavigationLink {
                                        FullAlertView(userVM: userVM, reportVM: viewModel, report: $viewModel.reports[index])
                                    } label: {
                                        AlertBlockView(alert: viewModel.reports[index])
                                            .padding(.bottom)
                                    }
                                }
                            }

                        }

                    if !viewModel.reports.filter({ $0.resolved }).isEmpty {
                        Text("Resolved Reports")
                            .font(.headline)
                            .foregroundStyle(.text.opacity(0.6))
                            .padding(.top)

                        ForEach(Array(viewModel.reports.enumerated()), id: \.element.id) { index, report in
                            if report.resolved {
                                NavigationLink {
                                    FullAlertView(userVM: userVM, reportVM: viewModel, report: $viewModel.reports[index])
                                } label: {
                                    AlertBlockView(alert: viewModel.reports[index])
                                        .padding(.bottom)
                                }
                            }
                        }
                    }

                }
                .padding(.horizontal)
            }
            .background {
                Color.bg.edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            NotificationManager.shared.requestNotificationPermission()
        }
    }
}
struct AlertBlockView: View {
    var alert: Report
    
    var body: some View {
        ZStack {
            if !alert.resolved {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.bg)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accent, lineWidth: 2)
                    )
                    .shadow(color: alert.urgencyLevel == "High" ? .alert.opacity(0.5) : .text.opacity(0.3), radius: 8)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.bg)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accent, lineWidth: 2)
                    )
                    .shadow(color: .green.opacity(0.5), radius: 8)
            }
                        
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(alert.urgencyLevel)
                        .font(.caption)
                        .foregroundStyle(alert.urgencyLevel == "High" ? .alert : .alert.opacity(0.5))
                        .bold(alert.urgencyLevel == "low" ? false : true)
                    
                    Text(alert.description)
                        .font(.headline)
                        .foregroundStyle(.text)
                        .multilineTextAlignment(.leading)
                    
                    Text(alert.address ?? "No Address")
                        .font(.subheadline)
                        .foregroundStyle(Color.accent)
                    
                    Text(timeAgoString(date: alert.time))
                        .font(.subheadline)
                        .foregroundStyle(.text.opacity(0.5))
                }
                .padding()
                Spacer()
            }

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
