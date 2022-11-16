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
    @Environment(\.colorScheme) var colorScheme
    init(){
        FirebaseApp.configure()
        //This will change the font size of the picker
        UISegmentedControl.appearance().selectedSegmentTintColor = .gray
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .headline)], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.black], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .headline)], for: .selected)
        
        //Needed to alter the font color for some reason inline declarations dont work
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
    }
    
    var body: some Scene {
        WindowGroup {
            Splashview()
        }
    }
}
