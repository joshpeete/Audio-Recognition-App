//CONTROLS THE "CARD"
//  CardView.swift
//  RMApp
//
//  Created by Joshua Peete on 10/5/22.
//
import SwiftUI
import AVFoundation
import Firebase
import FirebaseStorage
import UIKit
import MobileCoreServices
import FirebaseFirestore

struct CardView: View {
    @State var showMenu = true
    var body: some View {
        HStack{
            Button(action: { FirebaseInterface.instance.signOut() }) {
                Text("Sign Out")
            }
            .padding()
            .buttonStyle(.bordered)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}

