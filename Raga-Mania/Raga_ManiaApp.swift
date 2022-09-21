//
//  Raga_ManiaApp.swift
//  Raga-Mania
//
//  Created by Joshua Peete on 9/21/22.
//

import SwiftUI
import Firebase

@main
struct Raga_ManiaApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
