//
//  MissionView.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 5/3/25.
//

import SwiftUI

struct MissionView: View {
    @State var showSDG5 = false
    @State var showSDG10 = false
    
    var sdg5 = "PledgeGuard directly supports Target 5.3: Eliminate all harmful practices, such as child, early, and forced marriage. By enabling youth to report risk signs, raise awareness, and support survivors, we create a network protecting girls' rights and futures."
    
    var sdg10 = "PledgeGuard uplifts vulnerable communities by empowering those often silenced. Through anonymous reporting and access to localized support, we reduce barriers to safety, justice, and opportunity, regardless of geography, gender, or economic background."

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Text("PledgeGuard")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.accent)
                    
                    Text("Our Mission")
                        .font(.title2)
                        .foregroundColor(.alert)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Every minute, 22 children are forced into marriage.")
                            .font(.headline)
                            .foregroundStyle(.alert)
                        
                        Text("At PledgeGuard, we’re breaking that cycle, **together.**")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("We’re a youth-led movement using technology to fight child marriage by:")
                            .font(.headline)
                            .foregroundStyle(.text)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• Reporting risks **anonymously** to a community of pledgers")
                            Text("• Connecting girls to **support**, not silence")
                            Text("• Turning awareness into **action**")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.text)
                    }
                    
              
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What We Stand For")
                            .font(.headline)
                            .foregroundStyle(.text)
                        
                        Text("Tap below to learn more about how we stand for the Sustainable Development Goals.")
                            .font(.caption)
                            .foregroundStyle(.accent)
                        
                        Button {
                            showSDG5 = true
                        } label: {
                            Text("> **SDG 5**: Gender Equality")
                                .font(.subheadline)
                                .foregroundStyle(.text)
                        }
                        
                        Button {
                            showSDG10 = true
                        } label: {
                            Text("> **SDG 10**: Reduced Inequalities")
                                .font(.subheadline)
                                .foregroundStyle(.text)
                        }

                    }
                    .font(.subheadline)
                    .foregroundStyle(.text)
                    
           
                    Text("PledgeGuard isn’t just an app, it’s a **promise**. To protect, to prevent, and to never look away.")
                        .font(.headline)
                        .foregroundStyle(.accent)
                        .padding(.top)
                }
                .padding()
                .multilineTextAlignment(.leading)
            }
            .sheet(isPresented: $showSDG5){
                SDGExpandedView(sdg_num: 5, sdg_name: "Gender Equality", sdg_text: sdg5)
                    .presentationDetents([.fraction(0.4), .medium])
                
            }
            .sheet(isPresented: $showSDG10){
                SDGExpandedView(sdg_num: 10, sdg_name: "Reduced Inequalities", sdg_text: sdg10)
                    .presentationDetents([.fraction(0.4), .medium])

            }
            .background {
                Color.bg.edgesIgnoringSafeArea(.all)
            }
        }
    
    }
}

#Preview {
    MissionView()
}


struct SDGExpandedView: View {
    @Environment(\.dismiss) var dismiss
    
    let sdg_num: Int
    let sdg_name: String
    let sdg_text: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Text("PledgeGuard")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.accent)
                        .padding(.top)
                    
                    Text("Sustainable Development Goal \(sdg_num)")
                        .font(.title2)
                        .foregroundColor(.alert)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SDG \(sdg_num) - \(sdg_name)")
                            .font(.headline)
                            .foregroundStyle(.accent)
                        
                        Text(sdg_text)
                            .font(.subheadline)
                            .foregroundStyle(.text)

                    }
                }
                .padding()
            }
        }
    }
}
