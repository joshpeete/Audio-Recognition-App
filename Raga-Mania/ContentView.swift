//
//  ContentView.swift
//  Raga-Mania
//
//  Created by Joshua Peete on 9/21/22.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State private var email=""
    @State private var password=""
    @State private var userIsLoggedIn=false
    
    var body: some View {
        if userIsLoggedIn{
            ListView()
        }else{
            content
        }
    }
    
    var content: some View{
        ZStack {
            Color.black
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(LinearGradient(colors: [.green,.yellow], startPoint: .top, endPoint: .bottomTrailing))
                .frame(width: 1500, height: 600)
                .rotationEffect(.degrees(42))
                .offset(y:-450)
            
            VStack(spacing: 20){
                Text("Sign In")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x:-100,y:-200)
                
                TextField("Email",text:$email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty){
                        Text("Email")
                        .foregroundColor(.white)
                        .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                SecureField("Password",text:$password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty){
                        Text("Password")
                        .foregroundColor(.white)
                        .bold()
                    }
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.linearGradient(colors:[.green,.yellow], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                }
                .padding()
                
                Button {
                    login()
                } label: {
                    Text("Already Have an Account? Login")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding()
            }
            .frame(width: 350)
            .onAppear{
                Auth.auth().addStateDidChangeListener { Auth, user in
                    if user != nil {
                        userIsLoggedIn.toggle()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    func login(){
        Auth.auth().signIn(withEmail: email, password: password){result, error in
            if error != nil{
                print(error!.localizedDescription)
            }
        }
    }
    
    func register(){
        Auth.auth().createUser(withEmail: email, password: password){result, error in
            if error != nil{
                print(error!.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
