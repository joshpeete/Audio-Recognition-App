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
    //used to hold the information that went inside of the card when matching songs, now it controls the PFP
    
    @State var email = ""
    //figure out how to call the email from firestore and call it here to be displayed
    var body: some View {
        List{
            Section("Profile Page"){
                VStack(spacing: 12){
                Text("First Name")
                }
                VStack(spacing: 12){
                Text("Last Name")
                }
                VStack(spacing: 12){
                    TextField("Email", text:$email)
                }
            }
        }
    }
}

    struct CardView_Previews: PreviewProvider {
        static var previews: some View {
            CardView()
        }
    }

