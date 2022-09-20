//
//  ContentView.swift
//  Raga-mania
//
//  Created by Joshua Peete on 9/16/22.
//

import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject{
    
    let auth = Auth.auth()
    
    var isSignedIn: Bool{
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password){ result;,error)i
            guard result != nil, error == nil else {
                return}
            }
    }
    
    func signUp(email:String, password:String){
        
    }
    
}

struct ContentView: View {
    @State var email = ""
    var body: some View {
        NavigationView{
            VStack{
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width:200, height:200)
                
                VStack{
                    TextField("Email Address", text: $email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    SecureField("Email Address", text: $email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    Button(action: {
                        
                    }, label: {
                        Text("Sign In")
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .foregroundColor(Color.white)
                    })
                }
                .padding()
                Spacer()
                }
            .navigationTitle("Sign In")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
