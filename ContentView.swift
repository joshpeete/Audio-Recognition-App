//
//  ContentView.swift
//  Raga-Mania
//
//  Created by Joshua Peete on 9/21/22.
//

import SwiftUI
struct ContentView: View {
    
    @State private var email=""
    @State private var password=""
    @State private var userIsLoggedIn=false
    @State private var select=false
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    Picker(selection: $select, label: Text("Picker here")){
                        Text("Login")
                            .tag(true)
                            .foregroundColor(.white)
                        Text("Create Account")
                            .tag(false)
                            .foregroundColor(.black)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Button{
                        
                    }label: {
                        Image(systemName: "person.fill")
                            .font(.system(size: 75))
                            .padding()
                    }
                    TextField("Email",text:$email)
                        .foregroundColor(.white)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textFieldStyle(.plain)
                        .placeholder(when: email.isEmpty){
                            Text("Email")
                                .foregroundColor(.white)
                                .bold()
                        }
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.black)
                    
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
                        .foregroundColor(.black)
                }.navigationTitle("Create Account")
                    .padding()
                
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
