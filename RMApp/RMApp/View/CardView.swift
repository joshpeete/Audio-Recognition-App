//CONTROLS THE "CARD"
//  CardView.swift
//  RMApp
//
//  Created by Joshua Peete on 10/5/22.
//

import SwiftUI

struct CardView: View {
    var cover: String
    @State private var offset = CGSize.zero
    @State private var color: Color = .black
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 320,height: 350)
                .border(.white,width: 6.0)
                .cornerRadius(4)
                .foregroundColor(color.opacity(0.9))
                .shadow(radius: 4)
            HStack{
                Text(cover)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
        .offset(x:offset.width, y:offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width/60)))
        .gesture(
            DragGesture()
                .onChanged{ gesture in
                    offset = gesture.translation
                    withAnimation{
                        changeColor(width: offset.width)
                    }
                }.onEnded{ _ in
                    withAnimation{
                        swipeCard(width: offset.width)
                        changeColor(width: offset.width)
                    }
                }
        )
    }
    func swipeCard(width:CGFloat){
        switch width{
        case -500...(-150):
            print("\(cover) disliked")
            offset = CGSize(width: -500, height: 0)
        case 150...500:
            print("\(cover) disliked")
            offset = CGSize(width: 500, height: 0)
        default:
            offset = .zero
        }
    }
    
    func changeColor(width:CGFloat){
        switch width{
        case -500...(-100):
            color = .red
        case 100...500:
            color = .green
        default:
            color = .black
        }
    }
    
    
    struct CardView_Previews: PreviewProvider {
        static var previews: some View {
            CardView(cover:"sound1.mp3")
        }
    }
}
