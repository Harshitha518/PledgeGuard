//
//  ResourceView.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 4/25/25.
//

import SwiftUI

struct ResourceView: View {
    @StateObject var viewModel = ResourceViewModel()

    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.bg)
                    .edgesIgnoringSafeArea(.all)
                
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
                        
                        Text("Resources")
                            .font(.title2)
                            .foregroundColor(.alert)
                        
                        Divider()
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading).multilineTextAlignment(.leading)
                    
                    LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                        Text("Information & Awareness")
                            .font(.headline)
                        ForEach(viewModel.resources.filter { $0.category == "Information & Awareness" }, id: \.self) { resource in
                            Link(destination: URL(string: resource.contentURL)!) {
                                resourceBlockView(resource: resource)
                            }
                            
                            
                        }
                        if (viewModel.resources.filter { $0.category == "Information & Awareness" }.count) % 2 == 0 {
                            Text("")
                        } else {
                            EmptyView()
                        }
                        
                        
                        Text("Helplines & Support")
                            .font(.headline)
                        ForEach(viewModel.resources.filter { $0.category == "Helplines & Support" }, id: \.self) { resource in
                            Link(destination: URL(string: resource.contentURL)!) {
                                resourceBlockView(resource: resource)
                            }
                        }
                        if (viewModel.resources.filter { $0.category == "Helplines & Support" }.count) % 2 == 0 {
                            Text("")
                        } else {
                            EmptyView()
                        }
                        
                        Text("Legal Aid & Advocacy")
                            .font(.headline)
                        ForEach(viewModel.resources.filter { $0.category == "Legal Aid & Advocacy" }, id: \.self) { resource in
                            Link(destination: URL(string: resource.contentURL)!) {
                                resourceBlockView(resource: resource)
                            }
                        }
                        if (viewModel.resources.filter { $0.category == "Legal Aid & Advocacy" }.count) % 2 == 0 {
                            Text("")
                        } else {
                            EmptyView()
                        }
                        
                    }
                    
                    Spacer()
                    
                    
                }
                .padding(.horizontal)
                .onAppear {
                    viewModel.fetchResources()
                    
                }
            }
            
            
        }
    }
}


struct resourceBlockView: View {
    var resource: Resource
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.bg)
                .frame(width: 175, height: 200)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.clear)
                        .stroke(Color.accent, lineWidth: 2)
                }
                .shadow(radius: 5)
            VStack {
                Text(resource.title)
                    .font(.headline)
                    .foregroundStyle(Color.accent)
                    .padding(10)
                Text(resource.region)
                    .font(.subheadline)
                    .foregroundStyle(.alert.opacity(0.5))
            }
            
        }
        .padding(.horizontal)
         
    }
}
    


#Preview {
    ResourceView()
}
