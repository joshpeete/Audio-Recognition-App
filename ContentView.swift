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
    @State private var select=false
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing:12){
                    Picker(selection: $select, label: Text("Picker here")){
                        Text("Login")
                            .tag(true)
                            .foregroundColor(.white)
                        Text("Create Account")
                            .tag(false)
                            .foregroundColor(.black)
                    }.pickerStyle(SegmentedPickerStyle())
                    if select{
                        Button{
                            
                        }label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 75))
                                .padding(12)
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
                        Text("Create Account")
                            .foregroundColor(.white)
                            .padding(.vertical,20)
                            .font(.system(size: 24))
                        Spacer()
                    }.background(Color.blue)
                        .frame(width: 250, height: 100, alignment: .center)
                        .padding()
                }
                
            }.navigationTitle(select ? "Log In" :" Create Account")
                .padding()
                .background(
                        LinearGradient(gradient: Gradient(colors: [.yellow, .green]), startPoint: .top, endPoint: .bottom)
                    )
               
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
