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

var isSaving: Bool = false

var Ragastring = ""
var RagaAccuracy = ""
var RagaFileName = ""
var RagaData = Data.init()



//let semaphore = DispatchSemaphore(value: 1)

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
    @State public var tempraga = ""
    @State public var tempconf = ""
    @State private var color: Color = .gray
    @StateObject var shazamSession = ShazamRecognizer()
    @State private var isImporting: Bool = false
    @State private var presentPopup: Bool = false
    @State private var isImporting2: Bool = false
    @State var audioPlayer: AVAudioPlayer!
    @ObservedObject var playlist = Playlist.instance
    @State var flag = false
    @State var showMenu = false
    @State var newButtonAction: Int? = nil
    @State var shouldRecord = true
    @State private var profile = false
    @State private var moreInfo = false
    

    
    
    
    var body: some View{
        NavigationView{
            VStack{
                Menu{
                                    Button("Sign Out", action: { FirebaseInterface.instance.signOut() })
                                    Button("Profile"){
                                        self.profile = true
                                    }
                                    Button("More Information"){
                                        self.moreInfo = true
                                    }
                                } label: {
                                    Label("", systemImage: "line.horizontal.3")
                                }
                                .background(
                                    NavigationLink(destination: CardView(), isActive: $profile) {
                                        EmptyView()
                                    })
                                .background(
                                    NavigationLink(destination: MoreInfo(), isActive: $moreInfo) {
                                        EmptyView()
                                    })
                                .imageScale(.large)
                                .offset(x:175)
                
                
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
                            
                            HStack{
                                NavigationLink(destination: NewButtonAction(),
                                               tag: 1,
                                               selection: $newButtonAction) {
                                    Button {
                                        isImporting.toggle()
                                       
                                    } label: {
                                        Text("Import Your Song Here")
                                    }
                                    .padding().foregroundColor(.black)
                                    .buttonStyle(.bordered)
                                }
                                
                                
                                
                            }
                            
                            
                            .fileImporter( isPresented: $isImporting, allowedContentTypes: [.wav], allowsMultipleSelection: false) { result in
                                do {
                                    guard let selectedFile: URL = try result.get().first else { return }
                                    guard selectedFile.startAccessingSecurityScopedResource() else { return }
                                    let data = try Data(contentsOf: selectedFile)
                                    
                                    isSaving=false
                                    
                                    
                      
                                    
                                    Ragastring = printres(url: selectedFile)
                                    RagaAccuracy = printAcc()
                                    RagaFileName = selectedFile.lastPathComponent
                                    RagaData = data
                                    
                
                                    newButtonAction = 1
                                    
                                  
                                    
                                   
                                    
                                                    
                                    
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
                                    }
                                    
                                    else{
                                        //or show the instructions
                                        ZStack{
                                            Rectangle()
                                                .frame(width: 380,height: 370)
                                                .cornerRadius(12)
                                                .foregroundColor(color.opacity(0.9))
                                                .shadow(radius: 4)
                                            HStack{
                                                Text("Press the Microphone     \n     to Get Started")
                                                    .foregroundColor(.white)
                                                    .bold()
                                            }
                                        }
                                        .buttonStyle(.bordered)
                                        .shadow(radius: 4)
                                    }
                                }
                                
                                HStack {
                                    Spacer()
                                    
                                    VStack {
                                        RecordButton(isRecording: $shazamSession.isRecording) {
                                            shazamSession.listenMusic(shouldRecognize: !shouldRecord) { url in
                                                do {
                                                    let data = try Data(contentsOf: url)
                                                    try upload(file: data, name: url.lastPathComponent, raga: printres(url: url), accuracy: printAcc())
                                                    print(url)
                                                    print("using live revording")
                                                    print("raga: " + printres(url: url))
//                                                    List(playlist.tracks) { track in
//                                                        NavigationLink(destination: DetailView(track: track)){
//                                                            Text("testing")
//                                                        }
//                                                        .listRowBackground(Color.clear)
//                                                    }
                                                    tempraga = printres(url: url)
                                                    tempconf = printAcc()
                                                    presentPopup = true
                                                    
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                        }.popover(isPresented: $presentPopup, arrowEdge: .bottom) {
                                            
                                            Label(tempraga, systemImage: "music.note.list").font(.system(size: 20)).background(.white, in: RoundedRectangle(cornerRadius: 1))
                                            
                                            Label(tempconf, systemImage: "percent").font(.system(size: 20)).background(.white, in: RoundedRectangle(cornerRadius: 1))
                                              .frame(width: 100, height: 100)
                                        }
                                        .alert(shazamSession.errorMsg,
                                               isPresented: $shazamSession.showError){
                                            Button("Close",role: .cancel){
                                            }
                                        }
                                    
                                        Toggle(isOn: $shouldRecord) {
                                            Text("Identify Raga").bold()
                                        }
                                        .frame(width: 250)
                                        
                                    }
                                    
                                    
                                    Spacer()
                                }
                                
                                if let track = shazamSession.matchedTrack, let url = track.appleMusicURL {
                                    
                                    Link(destination: url){
                                        
                                        Text("Add to your Library")
                                    }
                                    .buttonStyle(.bordered)
                                    .shadow(radius: 4)
                                    .padding(15)
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
    
    
    func plssave()
    {
        //upload(file: RagaData, name: RagaFileName, raga: Ragastring, accuracy: RagaAccuracy)

        if isSaving{
            upload(file: RagaData, name: RagaFileName, raga: Ragastring, accuracy: RagaAccuracy)
            isSaving = false
        }
        else{
            isSaving = false
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
    
    
    func upload(file: Data, name: String, raga: String, accuracy: String) -> String {
            guard let uid = Auth.auth().currentUser?.uid else { return "" }
            let userTracks = Firestore.firestore().collection("users").document(uid).collection("tracks")

            let ref = Storage.storage().reference()
            let fileRef = ref.child(uid).child(name)
            let uploadTask = fileRef.putData(file, metadata: nil) { metadata, error in
                if let error = error {
                    print("Failed to upload (name): (error)")
                }
                print("Completed upload of (name)")
            }
            uploadTask.resume()
            //tracks for updating files vaishu
            userTracks.addDocument(data: ["song": name, "filePath": fileRef.fullPath , "raga" : raga, "accuracy" : accuracy]) {error in

                if let error = error {
                    print("Failed to update (name): (error)")
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


