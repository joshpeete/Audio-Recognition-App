//
//  Splashview.swift
//  Raga-Mania
//
//  Created by Joshua Peete on 9/22/22.
//

import SwiftUI

struct Splashview: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View{
        if isActive{
            ContentView()
        }else{
        VStack{
            VStack{
                Image(systemName: "music.quarternote.3")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                Text("Raga-Mania")
                    .font(Font.custom("Baskerville-Bold", size: 26))
                    .foregroundColor(.black.opacity(0.80))
            }
        .scaleEffect(size)
        .opacity(opacity)
        .onAppear{
            withAnimation(.easeIn(duration: 1.2)){
                self.size = 0.9
                self.opacity = 1.0
            }
        }
    }
    .onAppear {
            DispatchQueue.main.asyncAfter(deadline:.now() + 2.0) {
                self.isActive = true
            }
        }
    }
}
}

struct Previews_Splashview_Previews: PreviewProvider {
    static var previews: some View {
        Splashview()
    }
}
