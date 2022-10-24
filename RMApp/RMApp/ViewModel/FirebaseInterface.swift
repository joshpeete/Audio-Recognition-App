//
//  FirebaseInterface.swift
//  RMApp
//
//  Created by Vaishnavi Nannur on 10/22/22.
//
//authentication fixed
import Foundation
import Firebase

class FirebaseInterface: ObservableObject {
    static let instance = FirebaseInterface()
    
    @Published var userIsLoggedIn = Auth.auth().currentUser != nil
    
    func signOut() {
        try? Auth.auth().signOut()
        userIsLoggedIn = false
    }
}
