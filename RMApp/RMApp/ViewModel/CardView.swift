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

var fname = ""
var lname = ""
var emailfb = ""
var docfb = Date()
var formatted = "" //formatted date
//var docfb = ""
struct CardView: View {
    var body: some View {
        
       
        
        List{
            Section("Profile Page"){
                VStack(spacing: 12){
                    Text("First Name : \(fname)")
                    //Text(fname)
                }
                VStack(spacing: 12){
                    Text("Last Name : \(lname)")
                }
                VStack(spacing: 12){
                    Text("Email: \(emailfb)")
                }
                VStack(spacing: 12){
                    Text("Account Created: \(formatted)")
                }
            }
        }
    }
}

//query to get first name
func GetFirstName(){

//func GetFirstName() {
    let group = DispatchGroup()
    
    let uid = Auth.auth().currentUser?.uid ?? ""
    //let uid = Auth.auth().currentUser!.uid

    group.enter()
    //Firestore.firestore().collection("users").document(uid).getDocument()
    let db = Firestore.firestore()

    let docRef = db.collection("users").document(uid)

    var firstname = ""
    
    
   
        docRef.getDocument(source: .cache){ (document, error) in
            if let document = document {
                firstname = String(describing: document.get("firstname")!)
                
            } else {
                print("Document does not exist in cache")
            }
        }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        
        
        group.leave()
        
        
        group.notify(queue: .main, execute:{
            AssignFirstName(fn: firstname)
        })
        
    }
    
    
        //return firstname

}

func AssignFirstName(fn : String)->String
{
    fname = fn
    
    return fname
    
}



//query to get last name
func GetLastName(){

//func GetFirstName() {
    let group = DispatchGroup()
    
    let uid = Auth.auth().currentUser?.uid ?? ""
    //let uid = Auth.auth().currentUser!.uid

    group.enter()
    //Firestore.firestore().collection("users").document(uid).getDocument()
    let db = Firestore.firestore()

    let docRef = db.collection("users").document(uid)

    var lastname = ""
    
    
   
        docRef.getDocument(source: .cache){ (document, error) in
            if let document = document {
                lastname = String(describing: document.get("lastname")!)
                
            } else {
                print("Document does not exist in cache")
            }
        }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        
        
        group.leave()
        
        
        group.notify(queue: .main, execute:{
            AssignLastName(ln: lastname)
        })
        
    }
    
    
        //return firstname

}

func AssignLastName(ln : String)->String
{
    lname = ln
    
    return lname
    
}

//query to get email and account creation date
func GetEmail(){

//func GetFirstName() {
    let group = DispatchGroup()
    
    let uid = Auth.auth().currentUser?.uid ?? ""
    //let uid = Auth.auth().currentUser!.uid

    group.enter()
    //Firestore.firestore().collection("users").document(uid).getDocument()
    let db = Firestore.firestore()

    let docRef = db.collection("users").document(uid)

    var email = ""
    var DOC = Date()
    
   
        docRef.getDocument(source: .cache){ (document, error) in
            if let document = document {
                email = String(describing: document.get("email") ?? " ")
                //DOC = String(describing: document.get("dateofcreation")!)
                //DOC = document.get("dateofcreation") as! Date
                DOC = (document.get("dateofcreation") as? Timestamp)?.dateValue() ?? Date()
                
            } else {
                print("Document does not exist in cache")
            }
        }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        
        
        group.leave()
        
        
        group.notify(queue: .main, execute:{
            AssignEmail(em: email)
            AssignDOC(doc: DOC)
            
        })
        
    }
    
    
        //return firstname

}

func AssignEmail(em : String)->String
{
    emailfb = em
    
    return emailfb
    
}
//func AssignDOC(doc : String)->String
func AssignDOC(doc : Date)->String
{
    
    //let df = DateFormatter()
    //docfb = df.date(from: doc)!
    
  
        docfb = doc
        
        formatted = docfb.formatted(date: .numeric, time: .omitted)
        
        
        return formatted
   
    
}


    struct CardView_Previews: PreviewProvider {
        static var previews: some View {
            CardView()
        }
    }

