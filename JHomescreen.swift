//
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

struct JHomescreen: View {
    private var cover: [String] = ["sound1.mp3","sound2.mp3","sound3.mp3"].reversed()
    @State private var select = false
    @State private var start = false
    @State private var saved = ""
    
    @State private var isImporting: Bool = false
    @ObservedObject var playlist = Playlist.instance


    
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
                        
                        //TextField(select ? "Recents":"Saved",text:$saved)
                        //   .textFieldStyle(.plain)
                        //   .font(.system(size: 18))
                        //  .padding(12)
                        //  .placeholder(when: saved.isEmpty){
                        //      Text(select ? "Recents":"Saved")
                        //         .foregroundColor(.black)
                        //         .font(.system(size: 18))
                        //         .bold()
                        //         .padding(12)
                        //  }//Temporary Place Holders for where audio files will be stored
                        
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
                                    
                                }label: {
                                    Image(systemName: "music.mic.circle.fill")
                                        .foregroundColor(.black)
                                        .font(.system(size: 150))
                                        .ignoresSafeArea()
                                }
                            }else{
                                VStack{
                                    ForEach(playlist.tracks) { track in
                                        Button(action: {
                                            play(soundWithPath: track.path)
                                         }) {
                                             Text("Play \(track.title)")
                                         }
                                    }
                                   /* Button(action: {
                                        play(soundWithPath: "Blinding Lights (The Weeknd Lofi Cover).wav")
                                    }) {
                                        Text("Play Blinding Lights")
                                    }
                                    
                                    
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
                                    })*/
                                    //importing of the files - vaishu
                                    Text("Import Files")
                                        .padding()
                                    Button(action:{
                                        isImporting.toggle()
                                        self.addData(filename: "", length: "")

                                    }) {
                                        Text("Import")
                                    }
                                        .padding()
                                    
                                    Spacer()
                                    
                                    Button(action: { FirebaseInterface.instance.signOut() }) {
                                        Text("Sign Out")
                                    }
                                    .padding()
                                    .buttonStyle(.bordered)
                                    .padding()
                                }
                            }
                        }
                    }
                }
                
                .navigationTitle("Raga-Mania")
                .onAppear { playlist.update() }
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [.yellow, .green]), startPoint: .top, endPoint: .bottom))
                .fileImporter(
                            isPresented: $isImporting,
                            allowedContentTypes: [.wav],
                            allowsMultipleSelection: false
                        ) { result in
                            do {
                                guard let selectedFile: URL = try result.get().first else { return }
                                guard selectedFile.startAccessingSecurityScopedResource() else { return }
                                let data = try Data(contentsOf: selectedFile)
                                
                                upload(file: data, name: selectedFile.lastPathComponent)
                                
//                                guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                                
                                selectedFile.stopAccessingSecurityScopedResource()
                            } catch {
                                Swift.print(error.localizedDescription)
                            }
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
    //vaishu adding data
    func addData(filename: String, length: String){
        let db = Firestore.firestore()
        db.collection("sample").addDocument(data: ["song": filename, "length": length]){error in
            
            if error == nil {
            }
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
