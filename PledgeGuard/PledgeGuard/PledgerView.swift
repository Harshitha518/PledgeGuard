//
//  PledgerView.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 5/3/25.
//

import SwiftUI

struct PledgerView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("PledgeGuard")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.accent)
                    
                    Text("Your Role as a Pledger")
                        .font(.title2)
                        .foregroundColor(.alert)
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("1. What It Means to Be a Pledger")
                            .font(.headline)
                            .foregroundStyle(.accent)
                            .padding(.bottom)
                        
                        Text("By taking the pledge, you've committed to **standing against child marriage** and supporting at-risk girls. You're part of a growing global network of individuals creating real change through awareness, reporting, and responsible action.")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                    }
                    .padding(.vertical)
                    
                    VStack(alignment: .leading) {
                        Text("2. What You Can Do")
                            .font(.headline)
                            .foregroundStyle(.alert)
                            .padding(.bottom)
                        
                        Text("**Reporting Concerns** - Use the PledgeGuard app to report suspected cases of child marriage anonymously. Reports are visible to the pledger community to help identify patterns and provide early warning signals in affected regions.")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.bottom)
                        
                        Text("**Raising Awareness** - Educate others about the dangers of child marriage. Share resources, spark conversations, and advocate for cultural change in your circles.")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.bottom)
                        
                        Text("**Supporting Survivors** - Direct at-risk individuals or survivors to available resources, including emotional support, legal aid, and helplines.")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.bottom)
                        
                        Text("**Inspiring Action** - Encourage your friends, family, and peers to join the movement by taking the pledge and committing to protect vulnerable girls.")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.bottom)
                    }
                    .padding(.vertical)
                    
                    VStack(alignment: .leading) {
                        Text("3. What You Should Not Do")
                            .font(.headline)
                            .foregroundStyle(.alert)
                            .padding(.bottom)
                        
                        
                        Text("While your intention to help is powerful, pledgers must always prioritize safety:")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.bottom)
                        
                        Text("**Do not intervene directly** in suspected cases unless you are trained and it is legally and personally safe to do so.")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.bottom)
                        
                        Text("**Do not confront individuals** involved in or suspected of facilitating child marriage.")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.bottom)
                        
                        Text("**Do not share identifying information** of victims or suspected individuals on public platforms.")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.bottom)
                    }
                    .padding(.vertical)
                    
                    VStack(alignment: .leading) {
                        Text("4. In High-Risk Situations")
                            .font(.headline)
                            .foregroundStyle(.alert)
                            .padding(.bottom)
                        
                        
                        Text("If you believe a girl is in immediate danger:")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.bottom)
                        
                        Text("**Contact local authorities** or child protection hotlines directly.")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.bottom)
                        
                        Text("Use the **Urgency Level** in the reporting form to mark it as high-risk so other pledgers are alerted.")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.bottom)
                        
                        Text("If you are unsure, check the app’s **Resources or Helplines** sections for guidance.")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.bottom)
                    }
                    .padding(.vertical)
                    
                    VStack(alignment: .leading) {
                        Text("5. Our Promise to You")
                            .font(.headline)
                            .foregroundStyle(.accent)
                            .padding(.bottom)
                        
                        
                        Text("We built PledgeGuard as a safe and anonymous platform. Your privacy is protected, and your voice matters. Together, we are creating a safer and more informed world for every girl.")
                            .font(.subheadline)
                            .foregroundStyle(.text)
                            .padding(.bottom)
                        
                    }
                    .padding(.vertical)

                    
                }
                .padding()
                .background {
                    Color.bg.edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}

#Preview {
    PledgerView()
}
