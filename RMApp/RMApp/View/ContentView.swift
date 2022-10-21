//STARTING PAGE
//  ContentView.swift
//User registration and Login pages
//Needs auth for email and password still
//  Raga-Mania
//
//  Created by Joshua Peete on 9/21/22.
//

import SwiftUI
import Firebase


struct ContentView: View {
    @State private var email = ""
    @State private var logOut = ""
    @State private var password = ""
    @State private var select = false
    @State private var isActive = false
    @State private var userIsLoggedIn = false

    var body: some View {
        if userIsLoggedIn{
            JHomescreen()//if the user creates an account or logs in send them to the home page
        }else{
            NavigationView{
                ScrollView{
                    VStack(spacing:12){
                        Picker(selection: $select, label: Text("Toggle Button")){
                            Text("Login")
                                .tag(true)
                                .foregroundColor(.white)
                            Text("Create Account")
                                .tag(false)//start on create account tab
                                .foregroundColor(.black)
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        if select{
                            Button{
                                //DONT ADD FUNCTION
                            }label: {
                                Image(systemName: "music.quarternote.3")
                                    .foregroundColor(.black)
                                    .font(.system(size: 90))
                                    .padding(28)
                            }
                            
                        }
                        TextField("Email",text:$email)
                            .foregroundColor(.white)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .placeholder(when: email.isEmpty){
                                Text("Email")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                                    .bold()
                                    .padding(12)
                            }
                        Rectangle()//line under email
                            .frame(width: 350, height: 1)
                            .foregroundColor(.black)
                        
                        SecureField("Password",text:$password)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .placeholder(when: password.isEmpty){
                                Text("Password")
                                    .foregroundColor(.black)
                                    .bold()
                                    .font(.system(size: 16))
                                    .padding(12)
                            }
                    }
                    Rectangle()//line under password
                        .frame(width: 350, height: 1)
                        .foregroundColor(.black)
                    
                    Button{
                        handleAction()
                    }label: {
                        HStack{
                            Spacer()
                            Text(select ? "Login" :"Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical,20)
                                .font(.system(size: 24, weight: .semibold))
                            Spacer()
                        }.background(Color.blue)
                            .frame(width: 250, height: 100, alignment: .center)
                            .padding()
                    }
                }.navigationTitle(select ? "Login" :"Create Account")
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.yellow, .green]), startPoint: .top, endPoint: .bottom)
                    )
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .ignoresSafeArea()
            
        }
    }
    func handleAction() {//links buttons to functions
        if select {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    func loginUser() {//login func
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else if let user = user {
                print(user)
                userIsLoggedIn = true
                isActive = false
            }
        }
    }
    
    func createNewAccount() {//createacc func
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
           if error != nil {
                print(error?.localizedDescription ?? "")
    }
            //add text pop-up that says user account created
            //userIsLoggedIn = true
            //isActive = false
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
