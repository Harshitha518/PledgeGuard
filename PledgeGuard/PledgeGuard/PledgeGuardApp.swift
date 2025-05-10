//
//  PledgeGuardApp.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 4/24/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        
        UNUserNotificationCenter.current().delegate = self
        return true
    }

   
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Foreground notification received")
        completionHandler([.banner, .sound])
    }
}



@main
struct PledgeGuardApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var userViewModel = UserViewModel()
    
    @StateObject var selectedTab = TabManager()
    
    @State private var showPledge = false
    
    @State var path = NavigationPath()
    
    @StateObject var reportViewModel = ReportViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab.selectedTab) {
                    ReportView(path: $path)
                        .tabItem {
                            Label("Report", systemImage: "exclamationmark.triangle")
                        }
                        .tag(0)
                        .environmentObject(selectedTab)
                    
                    AlertView(viewModel: reportViewModel, userVM: userViewModel)
                        .tabItem {
                            Label("Alerts", systemImage: "megaphone")
                        }
                        .tag(1)
                
                ProfileView(viewModel: userViewModel, path: $path)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(2)
                        .environmentObject(selectedTab)
                    

                    
                    MapView(viewModel: reportViewModel)
                        .tabItem {
                            Label("Statistics", systemImage: "globe.europe.africa.fill")
                        }
                        .tag(3)
                    
                    ResourceView()
                        .tabItem {
                            Label("Resources", systemImage: "square.grid.3x3.topleft.filled")
                        }
                        .tag(4)
            }
            
            .background {
                Color.bg
            }
            .onAppear {
                reportViewModel.startListeningForReports()
                
                if Auth.auth().currentUser == nil {
                    Auth.auth().signInAnonymously { (authResult, error) in
                        if let error = error {
                            print("Error signing in anonymously: \(error.localizedDescription)")
                        } else {
                            print("Signed in anonymously with UID: \(authResult?.user.uid ?? "")")
                            userViewModel.fetchUser()
                        }
                    }
                } else {
                    print("User already signed in with UID: \(Auth.auth().currentUser?.uid ?? "")")
                    userViewModel.fetchUser()
                }
                let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
                if !hasLaunchedBefore {
                    showPledge = true
                    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                }
                
            }
            .sheet(isPresented: $showPledge){
                PledgeView(viewModel: userViewModel)
                    .interactiveDismissDisabled()
            }
            
        }
    }
}


class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

   
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Permission granted for notifications.")
            } else {
                print("Permission denied.")
            }
        }
    }

   
    func sendLocalNotification(title: String, body: String) {
        print("Scheduling notification: \(title) - \(body)") 
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

}


class TabManager: ObservableObject {
    @Published var selectedTab: Int = 2
}
