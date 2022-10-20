//
//  RMAppApp.swift
//  RMApp
//
//  Created by Joshua Peete on 9/27/22.
//

import SwiftUI
import Firebase

@main
struct RMAppApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Splashview()
        }
    }
}
