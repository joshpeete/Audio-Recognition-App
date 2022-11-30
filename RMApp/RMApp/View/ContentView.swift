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
    
    
    
    //@ObservedObject var sessionStore = SessionStore()
    
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
                .background(LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .top, endPoint: .bottom))
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .ignoresSafeArea()
            //alert needs to go here
        }
    }
        
    
    
func handleAction() {//links buttons to functions
    if email.isEmpty || password.isEmpty || firstname.isEmpty || lastname.isEmpty{
        print("These fields cannot be empty")
    } else if validatePassword != password{
            print("The password's you've entered do not match")
        }else{
            if isValidEmail(email) && isValidPasswordString(password) {
                if select {
                    loginUser()
                } else {
                    createNewAccount()
                }
            }else{
                print("Invalid Submission")
            }
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
    
    //josh
    func loginUser() {//login func
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error{
                print(error.localizedDescription)
                firebase.userIsLoggedIn = false
            }else{
                firebase.userIsLoggedIn = true
                print("Successful Login")
                Playlist.instance.update()
            }
        }
   }
    
    func createNewAccount(){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                
            }
            else{
                //if no error store user information
                
                
                
                let db = Firestore.firestore()
                
//                db.collection("users").addDocument(data:["firstname" : firstname , "lastname": lastname, "uid" : user!.user.uid,"dateofcreation" : Date() ]){ (error) in
//
//                }
                
                db.collection("users").document(user!.user.uid).setData(["firstname" : firstname , "lastname": lastname, "uid" : user!.user.uid,"dateofcreation" : Date() ])
                print("Account Successfully Created")
                
            }
            
            
            
            //add text pop-up that says user account created
            //firebase.userIsLoggedIn = true
            //isActive = false
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
   
    // function that will show messages on error pop up
    func validateFields() -> String?{
        
        //Check required fields are filled in
        if email == "" || password == "" || firstname == "" || lastname == ""{
            print("error, one of these fields is incorrect")
        }
        
        let passwordAttempt = password
        
        if isValidPasswordString(passwordAttempt) == false {
            return " Please make sure password is at least 8 characters, contains special character, contains a number"
        }
        
        return nil
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
