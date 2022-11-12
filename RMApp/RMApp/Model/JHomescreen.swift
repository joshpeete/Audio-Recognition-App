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
    var title: String
    var artist: String
    var artwork: URL
    var appleMusicURL: URL
    var path: String
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
    @State var showMenu = false
    
    var body: some View{
        NavigationView{
            VStack{
                Button{
                    self.showMenu.toggle()
                }label: {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(.black)
                }
                .buttonStyle(.bordered)
                
                
                if self.showMenu {
                    CardView()
                }
                
                
                VStack {
                    Picker(selection: $select, label: Text("Toggle Button")){
                        Text("Saved")
                            .tag(true)
                            .foregroundColor(.black)
                            .font(.largeTitle)
                        Text("Home")
                            .tag(false)
                            .foregroundColor(.black)
                            .font(.largeTitle)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .font(.largeTitle)
                    .padding(10)
                    
                    VStack{
                        if select {
                            //Start of Saved Page - Josh
                            
                            HStack{ Button(action:{
                                isImporting.toggle()
                                self.addData(filename: "", length: "")
                            })
                                {Text("Import Your Song Here")}
                                    .padding().foregroundColor(.black)
                                    .buttonStyle(.bordered)
                            }
                            
                            .fileImporter( isPresented: $isImporting, allowedContentTypes: [.wav], allowsMultipleSelection: false) { result in
                                do {
                                    guard let selectedFile: URL = try result.get().first else { return }
                                    guard selectedFile.startAccessingSecurityScopedResource() else { return }
                                    let data = try Data(contentsOf: selectedFile)
                                    
                                    upload(file: data, name: selectedFile.lastPathComponent,raga: printres(url: selectedFile))
                                    
                                    
                                    //                                            ragaTable[selectedFile.lastPathComponent] = printres(url: selectedFile)
                                    //                                            print(ragaTable)
                                    
                                    selectedFile.stopAccessingSecurityScopedResource()
                                } catch {
                                    Swift.print(error.localizedDescription)
                                }
                            }
                            //End of Saved Page - Josh
                            List(playlist.tracks) { track in
                                NavigationLink(destination: DetailView(track: track)){
                                    AudioListView(title: track.title)
                                }
                                .listRowBackground(Color.clear)
                            }
                            .listStyle(.plain)
                            .scrollContentBackground(.hidden)
                            
                        }else{
                            ScrollView{
                                //Start of Home Page
                                ZStack{
                                    if let track = shazamSession.matchedTrack{
                                        //Blurred Image in the back
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
                                        //show the requested song
                                    }else{
                                        //or show the instructions
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
                                        .buttonStyle(.bordered)
                                        .shadow(radius: 4)
                                    }
                                }
                                
                                HStack {
                                    VStack {
                                        RecordButton(isRecording: $shazamSession.isListening) {
                                            shazamSession.listenMusic(shouldRecognize: true)
                                        }
                                        .alert(shazamSession.errorMsg,
                                               isPresented: $shazamSession.showError){
                                            Button("Close",role: .cancel){
                                            }
                                        }
                                        
                                        Text("Listen")
                                    }
                                    
                                    VStack {
                                        RecordButton(isRecording: $shazamSession.isRecording, filled: false) {
                                            shazamSession.listenMusic(shouldRecognize: false) { url in
                                                do {
                                                    let data = try Data(contentsOf: url)
                                                    //try upload(file: url, name: url.lastPathComponent,raga: printres(url: url) )
                                                    //try upload(file: url)
                                                    //upload(file: data, name: url.lastPathComponent, raga: printres(url: url))
                                                    print(url)
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                        }
                                        
                                        Text("Live Recording")
                                    }
                                }
                                
                                
                                if let track = shazamSession.matchedTrack{
                                    
                                    Link(destination: track.appleMusicURL){
                                        
                                        Text("Add to your Library")
                                    }
                                    .buttonStyle(.bordered)
                                    .shadow(radius: 4)
                                }
                                //End of homescreen- josh
                                
                            }
                        }
                    }
                    
                }
                
            }
            .navigationTitle("Raga-Mania")
            .foregroundColor(.black)
            .background(LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .top, endPoint: .bottom))
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
                player?.stop()
            } else if let error = error {
                print("Failed to download \(path): \(error)")
            }
        }
    }
    
    //vaishu - upload
    @discardableResult func upload(file: URL) throws -> String? {
        guard file.startAccessingSecurityScopedResource() else { return nil }
        let data = try Data(contentsOf: file)
        
        let result = upload(data: data, name: file.lastPathComponent)
        
        file.stopAccessingSecurityScopedResource()
        
        return result
    }
    
    
    @discardableResult func upload(data: Data, name: String) -> String {
        guard let uid = Auth.auth().currentUser?.uid else { return "" }
        let userTracks = Firestore.firestore().collection("users").document(uid).collection("tracks")
        
        let ref = Storage.storage().reference()
        let fileRef = ref.child(uid).child(name)
        let uploadTask = fileRef.putData(data, metadata: nil) { metadata, error in
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
    
    
    func upload(file: Data, name: String, raga: String) -> String {
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
        userTracks.addDocument(data: ["song": name, "filePath": fileRef.fullPath , "raga" : raga]) {error in
            
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

