//HOME PAGE
//  JHomescreen.swift
//  RMApp
//
//  Created by Joshua Peete on 9/27/22.
//

import SwiftUI
import AVFoundation
import Firebase
import FirebaseStorage
import UIKit
import MobileCoreServices
import FirebaseFirestore

var player:AVAudioPlayer!

struct Track: Identifiable{
    var id = UUID().uuidString
    //Track info
    var title: String
    var artist: String
    var artwork: URL
    
}

struct JHomescreen: View {
    @State private var select = false
    @State private var start = false
    @State private var saved = ""
    @State private var color: Color = .gray
    @StateObject var shazamSession = ShazamRecognizer()
    @State private var isImporting: Bool = false
    @State var audioPlayer: AVAudioPlayer!
    @ObservedObject var playlist = Playlist.instance
    @State var flag = false
    
    var body: some View{
        NavigationView{
            VStack(spacing:12){
                Button(action: { FirebaseInterface.instance.signOut() }) {
                    Text("Sign Out").foregroundColor(.red)
                }
                .padding(.bottom).foregroundColor(.black)
                .buttonStyle(.bordered)
                ScrollView{
                    VStack {
                        Picker(selection: $select, label: Text("Toggle Button")){
                            Text("Home")
                                .tag(true)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                            Text("Saved")
                                .tag(false)
                                .foregroundColor(.black)
                                .font(.largeTitle)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .font(.largeTitle)
                        .padding()
                        
                        VStack{
                            if select {
//Start of HomePage
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
                                                .frame(width: 380,height: 370)
                                                .cornerRadius(12)
                                                .foregroundColor(color.opacity(0.9))
                                                .shadow(radius: 4)
                                            HStack{
                                                Text("Press the Microphone \n to Get Started")
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
//End of HomePage
                            }else{
                                
                                if flag == true{
                                    VStack{
                                        Label("Raga: \(printres())", systemImage: "music.note.list").font(.system(size: 20)).background(.white, in: RoundedRectangle(cornerRadius: 1))
                                           
                                    }
                                }
//Start of Saved Page
                                ForEach(playlist.tracks) { track in
                                        //
                                        Text("\(track.title)")
                                            .padding()
                                            .foregroundColor(.black)
                                            .border(.black, width: 4)
                                        
//                                        Button(action:{
//                                            isImporting.toggle()
//                                            self.addData(filename: "", length: "")
//                                        })
//                                        {Text("Import Your Song Here")}
//                                            .padding()
//                                            .buttonStyle(.bordered)
                                        HStack{
                                            Button(action:{
                                                play(soundWithPath: track.path)
                                            })
                                            {Image(systemName:"play.fill")}
                                                .padding()
                                                .buttonStyle(.bordered)
                                            
                                            Button(action:{
                                                pause(soundWithPath: track.path)
                                            })
                                            {Image(systemName:"pause.fill")}
                                                .padding()
                                                .buttonStyle(.bordered)
                                        }
                                    Button(action: {self.flag = true}){Text("Identify Raga")}
                                            .padding()
                                            .buttonStyle(.bordered).foregroundColor(.black)
                                       
                                    }
                                
//                                if flag == true{
//                                    VStack{
//                                        Text("\(printres())")
//                                    }
//                                }
                                
                                HStack{
                                    Button(action:{
                                        printStuff()
                                    })
                                    {Text("play test")}
                                            .padding().foregroundColor(.black)
                                        .buttonStyle(.bordered)
                                    
                                    Button(action:{
                                    isImporting.toggle()
                                    self.addData(filename: "", length: "")
                                })
                                {Text("Import Your Song Here")}
                                        .padding().foregroundColor(.black)
//                                    .buttonStyle(.bordered).fileImporter( isPresented: $isImporting, allowedContentTypes: [.wav], allowsMultipleSelection: false) { result in
//                                        do {
//                                            guard let selectedFile: URL = try result.get().first else { return }
//                                            guard selectedFile.startAccessingSecurityScopedResource() else { return }
//                                            let data = try Data(contentsOf: selectedFile)
//
//                                            upload(file: data, name: selectedFile.lastPathComponent)
//
//                                            selectedFile.stopAccessingSecurityScopedResource()
//                                        } catch {
//                                            Swift.print(error.localizedDescription)
//                                        }
//                                }
                                    
                                

                                    
                                    
                                }
                                
//                                    .fileImporter( isPresented: $isImporting, allowedContentTypes: [.wav], allowsMultipleSelection: false) { result in
//                                        do {
//                                            guard let selectedFile: URL = try result.get().first else { return }
//                                            guard selectedFile.startAccessingSecurityScopedResource() else { return }
//                                            let data = try Data(contentsOf: selectedFile)
//
//                                            upload(file: data, name: selectedFile.lastPathComponent)
//
//                                            selectedFile.stopAccessingSecurityScopedResource()
//                                        } catch {
//                                            Swift.print(error.localizedDescription)
//                                        }
//                                }
                            }
//End of Saved Page
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
    
    
    //this allows the uploaded file to be played - vaishu
    func play(soundWithPath path: String) {
        DownloadManager.instance.download(filePath: path) { data, error in
            print("Download of \(path) complete")
            if let data = data {
                player = try? AVAudioPlayer(data: data)
                player?.play()
                
            } else if let error = error {
                print("Failed to download \(path): \(error)")
            }
        }
    }
    //this func allows the uploaded file to be paused - Josh
    func pause(soundWithPath path: String) {
        DownloadManager.instance.download(filePath: path) { data, error in
            print("Download of \(path) complete")
            if let data = data {
                player = try? AVAudioPlayer(data: data)
                player?.pause()
            } else if let error = error {
                print("Failed to download \(path): \(error)")
            }
        }
    }
    
    //vaishu - upload
    func upload(file: Data, name: String) -> String {
        guard let uid = Auth.auth().currentUser?.uid else { return "" }
        let userTracks = Firestore.firestore().collection("users").document(uid).collection("tracks")
        
        let ref = Storage.storage().reference()
        let fileRef = ref.child(uid).child(name)
        let uploadTask = fileRef.putData(file, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to upload \(name): \(error)")
            }
            print("Completed upload of \(name)")
        }
        uploadTask.resume()
        //tracks for updating files vaishu
        userTracks.addDocument(data: ["song": name, "filePath": fileRef.fullPath]) {error in
            
            if let error = error {
                print("Failed to update \(name): \(error)")
            } else {
                self.playlist.update()
            }
        }
        return fileRef.fullPath
    }
    
    func upload2(file: Data, name: String) -> String {
        guard let uid = Auth.auth().currentUser?.uid else { return "" }
        let userTracks = Firestore.firestore().collection("users").document(uid).collection("tracks")
        
        let ref = Storage.storage().reference()
        let fileRef = ref.child(uid).child(name)
        let uploadTask = fileRef.putData(file, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to upload \(name): \(error)")
            }
            print("Completed upload of \(name)")
        }
        uploadTask.resume()
        //tracks for updating files vaishu
        userTracks.addDocument(data: ["song": name, "filePath": fileRef.fullPath]) {error in
            
            if let error = error {
                print("Failed to update \(name): \(error)")
            } else {
                self.playlist.update()
                
            }
        }
        return fileRef.fullPath
    }
    //vaishu adding data
    func addData(filename: String, length: String){
        let db = Firestore.firestore()
        db.collection("sample").addDocument(data: ["song": filename, "length": length]){error in
            if error == nil {
            }
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

