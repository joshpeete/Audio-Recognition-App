//
//  Raga_maniaApp.swift
//  Raga-mania
//
//  Created by Joshua Peete on 9/16/22.
//

import SwiftUI
import Firebase


@main
struct Raga_maniaApp: App {
    
    @UIApplicationDelegateAdaptor (AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    class AppDelegate: NSObject, UIApplicationDelegate{
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            
            FirebaseApp.configure()
            return true
        }
    }
}