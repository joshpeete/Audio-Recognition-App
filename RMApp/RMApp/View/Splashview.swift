//
//  Splashview.swift
//  Raga-Mania
//
//  Created by Joshua Peete on 9/22/22.
//

import SwiftUI
import Firebase

struct Splashview: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5

    var body: some View{
        if isActive{
            ContentView()//if the app is turned on show the registration/login page
        }else{//if the app isnt turned on yet show the splash screen
        VStack{
            VStack{
                Image(systemName: "music.quarternote.3")//logo
                    .font(.system(size: 100))
                    .foregroundColor(.black)
                Text("Raga-Mania")//title
                    .font(Font.custom("Baskerville-Bold", size: 26))
                    .foregroundColor(.black.opacity(0.80))
            }
        .scaleEffect(size)
        .opacity(opacity)
        .onAppear{
            withAnimation(.easeIn(duration: 1.2)){//fading animation
                self.size = 0.9
                self.opacity = 1.0
            }
        }
    }
    .onAppear {
            DispatchQueue.main.asyncAfter(deadline:.now() + 2.0) {
                self.isActive = true//activation
            }
        }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(LinearGradient(gradient: Gradient(colors: [.init(red: 0.67, green: 0.84, blue: 0.90), .init(red: 0.89, green: 0.84, blue: 0.90)]), startPoint: .top, endPoint: .bottom))

    }
}
}

struct Previews_Splashview_Previews: PreviewProvider {
    static var previews: some View {
        Splashview()
    }
}
