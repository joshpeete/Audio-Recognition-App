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
        //This will change the font size
           UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .headline)], for: .highlighted)
           UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .largeTitle)], for: .normal)
            
    }
    
    var body: some Scene {
        WindowGroup {
            Splashview()
        }
    }
}
