//
//  PrimosAppApp.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct PrimosAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            // ContentView()
            
            LogInView()
                .accentColor(Color(red: 194 / 255, green: 212 / 255, blue: 4 / 255))
        }
    }
}
