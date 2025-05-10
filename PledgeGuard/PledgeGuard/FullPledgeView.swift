//
//  FullPledgeView.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 5/6/25.
//

import SwiftUI

struct FullPledgeView: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("PledgeGuard")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.accent)
                        Text("Your Pledge")
                            .font(.title2)
                            .foregroundColor(.alert)
                        
                        Divider()
                        
                        Text(viewModel.user?.pledgeText ?? "")
                            .padding(.bottom)
                            .foregroundStyle(.text)
                        
                        
                    }
                    
                    Text("Signed By:")
                        .font(.caption)
                        .foregroundStyle(.accent)
                    Text(viewModel.user?.fullName ?? "")
                        .font(.headline)
                        .foregroundStyle(.text)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.text, lineWidth: 2))
                    
                    
                    HStack {
                        Text("Your role:   ")
                            .font(.headline)
                            .foregroundStyle(.text)
                        
                        Text(viewModel.user?.role ?? "")
                            .font(.title3)
                            .foregroundStyle(.accent)
                    }
                    
                }
                .background {
                    Color.bg.edgesIgnoringSafeArea(.all)
                }
                .padding(.horizontal)
            }
        }
    }
}
