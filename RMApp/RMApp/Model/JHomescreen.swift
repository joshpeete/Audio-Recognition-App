//HOME PAGE
//  JHomescreen.swift
//  RMApp
//
//  Created by Joshua Peete on 9/27/22.
//

import SwiftUI
import AVFoundation
import Firebase
import UIKit
import MobileCoreServices

var player:AVAudioPlayer!

struct Track: Identifiable{
    var id = UUID().uuidString
    //Track info
    var title: String
    var artist: String
    var artwork: URL
    
}

struct JHomescreen: View {
    private var cover: [String] = ["sound1.mp3","sound2.mp3","sound3.mp3"].reversed()
    @State private var select = false
    @State private var start = false
    @State private var saved = ""
    @State private var color: Color = .black
    @StateObject var shazamSession = ShazamRecognizer()
    @State private var isImporting: Bool = false
    @State var audioPlayer: AVAudioPlayer!
    
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
                    }
                    .font(.largeTitle)
                    .pickerStyle(SegmentedPickerStyle())
                    VStack{
                        if select {
                            ZStack{
                                if let track = shazamSession.matchedTrack{
                                    //Blurred Image
                                    AsyncImage(url: track.artwork){phase in
                                        if let image = phase.image{
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .cornerRadius(12)
                                        }
                                        else{
                                            Color.white
                                        }
                                    }
                                    .overlay(.ultraThinMaterial)
                                    //Track Info
                                    VStack(spacing: 15){
                                        AsyncImage(url: track.artwork){phase in
                                            if let image = phase.image{
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: getRect().width-150, height: 300)
                                                    .cornerRadius(12)
                                            }
                                            else{
                                                ProgressView()
                                            }
                                        }
                                        Text(track.title)
                                            .font(.title.bold())
                                        
                                        Text("Artist: **\(track.artist)**")
                                        
                                    }
                                }else{
                                    ZStack{
                                        Rectangle()
                                            .frame(width: 320,height: 350)
                                            .border(.white,width: 6.0)
                                            .cornerRadius(4)
                                            .foregroundColor(color.opacity(0.9))
                                            .shadow(radius: 4)
                                        HStack{
                                            Text("Press the Microphone")
                                                .foregroundColor(.white)
                                                .bold()
                                            Text("to Get Started")
                                                .foregroundColor(.white)
                                                .bold()
                                        }
                                    }
                                }
                            }
                            
                            Button{
                                //Button that starts Shazam functionality
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
                                    self.addData(filename: "sample-9s", length: "9sec")
                                })
                                {Text("Saved Raga 1")}
                                    .padding()
                                
                                Button(action:{
                                    self.playSound2()
                                    self.addData(filename: "sample-6s", length: "6sec")
                                })
                                {Text("Saved Raga 2")}
                                    .padding()
                                
                                Button(action:{
                                    self.playSound3()
                                    self.addData(filename: "sample-15s", length: "15sec")

                                })
                                {Text("Saved Raga 3")}
                                    .padding()
                                
                                Button(action:{
                                    //self.importFiles(filename: "sample-15s", length: )
                                })
                                {Text("Import Files")}
                                    .padding()
                                
                                Button(action:{
                                    isImporting.toggle()
                                    self.addData(filename: "", length: "")

                                })
                                {Text("Import")}
                                    .padding()
                                
                                Button(action:{
                                    //
                                })
                                {Image(systemName:"playpause.fill")}
                                    .padding()
                            }
                        }
                    }.padding()
                        .onAppear{
                            let url = Bundle.main.url(forResource: "sound", withExtension: "mp3")
                            self.getData()
                        }
                }
            }
            .navigationTitle("Raga-Mania")
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [.yellow, .green]), startPoint: .top, endPoint: .bottom))
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [.mp3],
                allowsMultipleSelection: false
            ) { result in
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    guard selectedFile.startAccessingSecurityScopedResource() else { return }
                    
                    guard String(data: try Data(contentsOf: selectedFile), encoding: .utf8) != nil else { return }
                    
                    selectedFile.stopAccessingSecurityScopedResource()
                } catch {
                    Swift.print(error.localizedDescription)
                }
            }
        }
    }

    
    
func addData(filename: String, length: String){
    let db = Firestore.firestore()
    db.collection("sample").addDocument(data: ["song": filename, "length": length]){error in
        if error == nil{
        }
    }
}
 
    func getData(){
        let asset = AVAsset(url: self.audioPlayer.url!)
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

extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}

