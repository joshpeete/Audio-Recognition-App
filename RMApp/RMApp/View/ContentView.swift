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
    @State private var showResetPasswordConfirmation = false
    @State private var resetPasswordConfirmationAlert = false
    @ObservedObject var firebase = FirebaseInterface.instance
    
    var body: some View {
        if firebase.userIsLoggedIn{
            JHomescreen()//if the user creates an account or logs in send them to the home page
        }else{
            NavigationView{
                ScrollView{
                    VStack(spacing:12){
                        Picker(selection: $select, label: Text("Toggle Button")){
                            Text("Login")
                                .tag(true)
                                .foregroundColor(.black)
                            Text("Register")
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
                            .foregroundColor(.black)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .font(.system(size: 16))
                            .bold()
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
                            .frame(width: 400, height: 1)
                            .foregroundColor(.black)
                        
                        SecureField("Password",text:$password)
                            .foregroundColor(.black)
                            .textFieldStyle(.plain)
                            .bold()
                            .font(.system(size: 16))
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
                        .frame(width: 400, height: 1)
                        .foregroundColor(.black)
                    
                    Button{
                        handleAction()
                    }label: {
                        ZStack{
                            Text(select ? "Login" :"Create Account")
                                .foregroundColor(.white)
                                .padding()
                                .cornerRadius(12)
                                .font(.system(size: 24, weight: .semibold))
                        }.background(Color.blue)
                            .frame(width: 250, height: 100, alignment: .center)
                            .padding()
                            .cornerRadius(12)
                    }
                            ZStack{
                                Button {
                                    showResetPasswordConfirmation = true
                                } label: {
                                    Text("Forgot password?")
                                        .foregroundColor(.blue)
                                        .padding()
                                }
                                .alert(
                                    "Reset password",
                                    isPresented: $showResetPasswordConfirmation) {
                                        Button {
                                            resetPassword()
                                        } label: {
                                            Text("Reset password")
                                        }
                                        .keyboardShortcut(.defaultAction)
                                        .padding()
                                        Button {
                                            
                                        } label: {
                                            Text("Cancel")
                                        }
                                        .keyboardShortcut(.cancelAction)
                                        .padding()
                                        
                                    } message: {
                                        Text("Reset password for \(email)?")
                                    }
                                    .alert(
                                        "Email sent",
                                        isPresented: $resetPasswordConfirmationAlert) {
                                            
                                            Button {
                                                
                                            } label: {
                                                Text("OK")
                                            }.keyboardShortcut(.defaultAction)
                                            
                                        } message: {
                                            Text("A password reset email was sent to \(email). Check your email and follow instructions.")
                                        }
                            }
                    }
                .navigationTitle(select ? "Login" :"Create Account")
                .background(LinearGradient(gradient: Gradient(colors: [.yellow, .green]), startPoint: .top, endPoint: .bottom))
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
    
    //vaishu and josh
    func loginUser() {//login func
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            firebase.userIsLoggedIn = true
            isActive = false
            Playlist.instance.update()
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
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                self.resetPasswordConfirmationAlert = true
            }
            // error aler
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
