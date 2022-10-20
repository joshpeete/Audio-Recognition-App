//HOME PAGE
//  JHomescreen.swift
//  RMApp
//
//  Created by Joshua Peete on 9/27/22.
//

import SwiftUI
import AVFoundation

var player:AVAudioPlayer!

struct JHomescreen: View {
    private var cover: [String] = ["sound1.mp3","sound2.mp3","sound3.mp3"].reversed()
    @State private var select = false
    @State private var start = false
    @State private var saved = ""
    @StateObject var shazamSession = ShazamRecognizer()
    
    var body: some View {
            NavigationView{
                ScrollView{
                    VStack(spacing:12){
                        Picker(selection: $select, label: Text("Toggle Button")){
                            Text("Home")
                                .tag(true)
                                .foregroundColor(.white)
                            Text("Saved")
                                .tag(false)
                                .foregroundColor(.black)
                        }.pickerStyle(SegmentedPickerStyle())
                        VStack{
                            if select {
                                VStack{
                                    ZStack{
                                        ForEach(cover, id: \.self){ cover in
                                            CardView(cover: cover)
                                        }
                                    }
                                    Text("")
                                        .padding(2)
                                }
                                Button{
                                    //Button func will go here
                                    shazamSession.listenMusic()
                                }label: {
                                    Image(systemName: shazamSession.isRecording ? "stop.circle.fill" : "music.mic.circle.fill")
                                        .foregroundColor(.black)
                                        .font(.system(size: 150))
                                        .ignoresSafeArea()
                                }
                                .alert(shazamSession.errorMsg, isPresented: $shazamSession.showError){
                                    Button("Close",role: .cancel){
                                        
                                    }
                                }
                            }else{
                                VStack{
                                    Button(action:{
                                        self.playSound1()
                                    })
                                    {Text("Saved Raga 1")}
                                        .padding()
                                    Button(action:{
                                        self.playSound2()
                                    })
                                    {Text("Saved Raga 2")}
                                        .padding()
                                    Button(action:{
                                        self.playSound3()
                                    })
                                    {Text("Saved Raga 3")}
                                        .padding()
                                }
                            }
                        }
                    }
                }
                
                .navigationTitle("Raga-Mania")
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [.yellow, .green]), startPoint: .top, endPoint: .bottom))
            }
    }
    func playSound1(){
        let url = Bundle.main.url(forResource: "sample-9s", withExtension: "mp3")
        guard url != nil else{
            return
        }
        do{
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        }catch{
            print("error")
        }
    }
    
    func playSound2(){
        let url = Bundle.main.url(forResource: "sample-6s", withExtension: "mp3")
        guard url != nil else{
            return
        }
        do{
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        }catch{
            print("error")
        }
    }
    
    func playSound3(){
        let url = Bundle.main.url(forResource: "sample-15s", withExtension: "mp3")
        guard url != nil else{
            return
        }
        do{
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        }catch{
            print("error")
        }
    }
}
    
struct JHomescreen_Previews: PreviewProvider {
    static var previews: some View {
        JHomescreen()
    }
}
