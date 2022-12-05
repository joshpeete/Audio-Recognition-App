//
//  ContentView.swift
//User registration and Login pages
//Needs auth for email and password still
//  Raga-Mania
//
//  Created by Joshua Peete on 9/21/22.
//
import SwiftUI
import Firebase


enum ActiveAlert{
    case first
    case second
    case third
    case fourth
    case fifth
    case sixth
    case seventh
}

struct ContentView: View {
    @State public var firstname = ""
    @State public var lastname = ""
    @State public var email = ""
    @State private var logOut = ""
    @State private var password = ""
    @State private var validatePassword = ""
    @State private var select = false
    @State private var showResetPasswordConfirmation = false
    @State private var resetPasswordConfirmationAlert = false
    @ObservedObject var firebase = FirebaseInterface.instance
    
    @State private var showAlert1 = false
    @State private var showAlert2 = false
    @State private var showAlert3 = false
    @State private var showAlert4 = false
    @State private var showAlert5 = false
    @State private var showAlert6 = false
    //@ObservedObject var sessionStore = SessionStore()
    
    @State private var activeAlert:ActiveAlert = .first
    
    var body: some View {
        if firebase.userIsLoggedIn{
            JHomescreen()//if the user creates an account AND logs in send them to the home page
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
                            .foregroundColor(.black)
                        
                        if select{
                            Button{
                                //DONT ADD FUNCTION
                            }label: {
                                Image(systemName: "music.quarternote.3")
                                    .foregroundColor(.black)
                                    .font(.system(size: 90))
                            }
                            .padding()
                            
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
                                .frame(width: 375, height: 1)
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
                            Rectangle()//line under password
                                .frame(width: 375, height: 1)
                                .foregroundColor(.black)
                            
                            ZStack{
                                Button {
                                    showResetPasswordConfirmation = true
                                } label: {
                                    Text("Forgot password?")
                                        .foregroundColor(.black)
                                        .padding()
                                        .font(.system(size: 24, weight: .semibold))
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.gray)
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
                            }.offset(y:10)
                            
                        }else{
                            TextField("First Name",text:$firstname)
                                .foregroundColor(.black)
                                .keyboardType(.webSearch)
                                .autocapitalization(.none)
                                .font(.system(size: 16))
                                .bold()
                                .textFieldStyle(.plain)
                                .padding(12)
                                .placeholder(when: firstname.isEmpty){
                                    Text("First Name")
                                        .foregroundColor(.black)
                                        .font(.system(size: 16))
                                        .bold()
                                        .padding(12)
                                }
                            Rectangle()//line under email
                                .frame(width: 375, height: 1)
                                .foregroundColor(.black)
                            TextField("Last Name",text:$lastname)
                                .foregroundColor(.black)
                                .keyboardType(.webSearch)
                                .autocapitalization(.none)
                                .font(.system(size: 16))
                                .bold()
                                .textFieldStyle(.plain)
                                .padding(12)
                                .placeholder(when: lastname.isEmpty){
                                    Text("Last Name")
                                        .foregroundColor(.black)
                                        .font(.system(size: 16))
                                        .bold()
                                        .padding(12)
                                }
                            Rectangle()//line under email
                                .frame(width: 375, height: 1)
                                .foregroundColor(.black)
                            
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
                                .frame(width: 375, height: 1)
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
                            Rectangle()//line under
                                .frame(width: 375, height: 1)
                                .foregroundColor(.black)
                            
                            SecureField("Confirm Password",text:$validatePassword)
                                .foregroundColor(.black)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .font(.system(size: 16))
                                .bold()
                                .textFieldStyle(.plain)
                                .padding(12)
                                .placeholder(when: validatePassword.isEmpty){
                                    Text("Confirm Password")
                                        .foregroundColor(.black)
                                        .font(.system(size: 16))
                                        .bold()
                                        .padding(12)
                                }
                            
                            Rectangle()//line under
                                .frame(width: 375, height: 1)
                                .foregroundColor(.black)
                        }
                    }
//                    .alert(isPresented: self.$showAlert1){
//                        Alert(
//                                                    title: Text("No Email Or Password"),
//                                                    dismissButton: .default(Text("Ok"))
//
//                                                )
//                    }
//
//                    .alert(isPresented: self.$showAlert2){
//                        Alert(
//                                                    title: Text("Fields Cannot Be Empty"),
//                                                    dismissButton: .default(Text("Ok"))
//
//                                                )
//                    }
//                    .alert(isPresented: self.$showAlert3){
//                        Alert(
//                                                    title: Text("Passwords Do Not Match"),
//                                                    dismissButton: .default(Text("Ok"))
//
//                                                )
//                    }
//                    .alert(isPresented: self.$showAlert4){
//                        Alert(
//                                                    title: Text("Account Successfully Created"),
//                                                    dismissButton: .default(Text("Ok"))
//
//                                                )
//                    }
//                    .alert(isPresented: self.$showAlert5){
//                        Alert(
//                                                    title: Text("Account Already Exists"),
//                                                    dismissButton: .default(Text("Ok"))
//
//                                                )
//                    }
//                    .alert(isPresented: self.$showAlert6){
//                        Alert(
//                                                    title: Text("Invalid Credentials"),
//                                                    dismissButton: .default(Text("Ok"))
//
//                                                )
//                    }
                    .alert(isPresented: self.$showAlert1){
                        switch activeAlert{
                        case .first:
                            return Alert(
                                title: Text("No Email Or Password"),
                                dismissButton: .default(Text("Ok"))
                                
                                
                            )
                        case .second:
                            return  Alert(
                                title: Text("Fields Cannot Be Empty"),
                                dismissButton: .default(Text("Ok"))
                                
                            )
                        case .third:
                            return  Alert(
                                title: Text("Passwords Do Not Match"),
                                dismissButton: .default(Text("Ok"))
                                
                            )
                        case .fourth:
                            return Alert(
                                title: Text("Passwords Do Not Match"),
                                dismissButton: .default(Text("Ok"))
                                
                            )
                        case .fifth:
                            return    Alert(
                                title: Text("Account Already Exists"),
                                dismissButton: .default(Text("Ok"))
                                
                            )
                        case .sixth:
                            return  Alert(
                                title: Text("Invalid Credentials"),
                                dismissButton: .default(Text("Ok"))
                                
                            )
                        case .seventh:
                            return  Alert(
                                title: Text("Account Successfully Created"),
                                dismissButton: .default(Text("Ok"))
                                
                            )
                        }
                    }
                    
//Registration Page End
                    Button{
                        handleAction()
                    }
                label: {
                        ZStack{
                            Text(select ? "Login" :"Create Account")
                                .foregroundColor(.black)
                                .padding()
                                .cornerRadius(12)
                                .font(.system(size: 24, weight: .semibold))
                        }
                    }
                .buttonStyle(.borderedProminent)
                .padding()
                }
                .navigationTitle(select ? "Login" :"Create Account")
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [.init(red: 0.67, green: 0.84, blue: 0.90), .init(red: 0.89, green: 0.84, blue: 0.90)]), startPoint: .top, endPoint: .bottom))
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .ignoresSafeArea()
            .foregroundColor(.black)
        }
    }
    
//func handleAction() {//links buttons to functions
//        if email.isEmpty || password.isEmpty{
//            showAlert1 = true
//        }else if validatePassword != password{
//            print("The password's you've entered do not match")
//        }else{
//            if isValidEmail(email) && isValidPasswordString(password) {
//                if select {
//                    loginUser()
//                } else {
//                    createNewAccount()
//                }
//            }else{
//                print("Invalid Submission")
//            }
//        }
//    }
    
    
    func handleAction() {//links buttons to functions

                    if select {
                        loginUser()
                    } else {
                        createNewAccount()
                    }
                }
    
    
//josh
func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

//josh
func isValidPasswordString(_ password:String) -> Bool {
        let pwdRegEx = "(?:(?:(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_])|(?:(?=.*?[0-9])|(?=.*?[A-Z])|(?=.*?[-!@#$%&*ˆ+=_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_]))[A-Za-z0-9-!@#$%&*ˆ+=_]{6,15}"

        let pwdTest = NSPredicate(format:"SELF MATCHES %@", pwdRegEx)
        return pwdTest.evaluate(with: password)
    }
    

    
//    func loginUser() {//login func
//           Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//               if let error = error{
//                   print(error.localizedDescription)
//                   firebase.userIsLoggedIn = false
//               }else{
//                   firebase.userIsLoggedIn = true
//                   print("Successful Login")
//                   Playlist.instance.update()
//                   GetFirstName()
//                   GetLastName()
//                   GetEmail()
//               }
//           }
//      }
    
    func loginUser() {//login func
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if email.isEmpty || password.isEmpty{
                    //print("These fields cannot be empty")
                    showAlert1 = true
                    self.activeAlert = .first
                }
                    
//                }else if isValidEmail(email) && isValidPasswordString(password){
//                        firebase.userIsLoggedIn = true
//                        print("Successful Login")
//                        Playlist.instance.update()
//                        GetFirstName()
//                        GetLastName()
//                        GetEmail()
//                    }
                
                
//                else {let error = error
//                    print(error?.localizedDescription)
//                    //showAlert6 = true
//                    showAlert1 = true
//                    self.activeAlert = .sixth
//                }
                else if error != nil{
                    let error = error
                    print(error?.localizedDescription)
                    //showAlert6 = true
                    showAlert1 = true
                    self.activeAlert = .sixth
                    
                }
                else{
                    firebase.userIsLoggedIn = true
                    print("Successful Login")
                    Playlist.instance.update()
                    GetFirstName()
                    GetLastName()
                    GetEmail()
                }
                
                }
            }
    
//    func createNewAccount(){
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//            if error != nil {
//                print(error?.localizedDescription ?? "")
//
//            }
//            else{
//
//                let db = Firestore.firestore()
//
//
//                db.collection("users").document(user!.user.uid).setData(["firstname" : firstname , "lastname": lastname, "uid" : user!.user.uid,"dateofcreation" : Date(), "email" : email])
//
//            }
//
//        }
//    }
    
    func createNewAccount(){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if email.isEmpty || password.isEmpty || firstname.isEmpty || lastname.isEmpty || validatePassword.isEmpty{
                print("These fields cannot be empty")
                //showAlert2 = true
                showAlert1 = true
                self.activeAlert = .second
            } else if validatePassword != password{
                print("The password's you've entered do not match")
                //showAlert3 = true
                showAlert1 = true
                self.activeAlert = .third
            }
//            else if isValidEmail(email) && isValidPasswordString(password){
//                //if no error store user information
//                let db = Firestore.firestore()
//
//
//                db.collection("users").document(user!.user.uid).setData(["firstname" : firstname , "lastname": lastname, "uid" : user!.user.uid,"dateofcreation" : Date(), "email" : email])
//                print("Account Successfully Created")
//                //showAlert4 = true
//                showAlert1 = true
//                self.activeAlert = .fourth
//
//            }
            //else {let error = error
            else if error != nil{
                print(error?.localizedDescription)
                //showAlert5 = true
                showAlert1 = true
                self.activeAlert = .fifth
            }
            //add text pop-up that says user account created
            
            else{
                //if no error store user information
                let db = Firestore.firestore()
                
                
                db.collection("users").document(user!.user.uid).setData(["firstname" : firstname , "lastname": lastname, "uid" : user!.user.uid,"dateofcreation" : Date(), "email" : email])
                print("Account Successfully Created")
                //showAlert4 = true
                showAlert1 = true
                self.activeAlert = .seventh
                
            }
        }
    }
    
    
    
    
    
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                self.resetPasswordConfirmationAlert = true
            }
            // error alert
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
