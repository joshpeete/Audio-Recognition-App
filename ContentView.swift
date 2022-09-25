//
//  ContentView.swift
//  Raga-Mania
//
//  Created by Joshua Peete on 9/21/22.
//

import SwiftUI
import Firebase

class FirebaseManager: NSObject {
    let auth: Auth
    static let shared = FirebaseManager()
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        super.init()
    }
}

struct ContentView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var select = false
    @State var loginStatusMessage = ""
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing:12){
                    Picker(selection: $select, label: Text("Toggle Button")){
                        Text("Create Account")
                            .tag(true)
                            .foregroundColor(.white)
                        Text("Login")
                            .tag(false)
                            .foregroundColor(.black)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if select{
                        Button{
                            
                        }label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 75))
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
                    Rectangle()
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
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.black)
                
                Button{
                    
                }label: {
                    HStack{
                        Spacer()
                        Text(select ? "Create Account" :"Log In")
                            .foregroundColor(.white)
                            .padding(.vertical,20)
                            .font(.system(size: 24, weight: .semibold))
                        Spacer()
                    }.background(Color.blue)
                        .frame(width: 250, height: 100, alignment: .center)
                        .padding()
                }
                Text(self.loginStatusMessage)
                    .foregroundColor(.red)
                
            }.navigationTitle(select ? "Create Account" :"Log In")
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [.yellow, .green]), startPoint: .top, endPoint: .bottom)
                )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        func handleAction() {
            if select {
                loginUser()
            } else {
                createNewAccount()
            }
        }
        
        func loginUser() {
            FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
                if let err = err {
                    print("Failed to login user:", err)
                    self.loginStatusMessage = "Failed to login user: \(err)"
                    return
                }
                
                print("Successfully logged in as user: \(result?.user.uid ?? "")")
                
                self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            }
        }
        
        
        func createNewAccount() {
            FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
                if let err = err {
                    print("Failed to create user:", err)
                    self.loginStatusMessage = "Failed to create user: \(err)"
                    return
                }
                
                print("Successfully created user: \(result?.user.uid ?? "")")
                
                self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
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
