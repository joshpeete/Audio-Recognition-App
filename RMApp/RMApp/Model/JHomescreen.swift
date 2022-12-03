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

struct Track: Identifiable{
    var id = UUID().uuidString
    var title = ""
    var artist = ""
    var artwork: URL? = nil
    var appleMusicURL: URL? = nil
    var path = ""
    var raga = ""
    var date: Date? = nil
    var confidenceLevel = 0
}

enum SortOptions: Int, Hashable {
    case ascendingDate
    case descendingDate
    case confidenceLevel
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
    @State var newButtonAction: Int? = nil
    @State var shouldRecord = true
    @State var ascending = false
    
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
                            
                            HStack {
                                Button {
                                    isImporting.toggle()
                                    self.addData(filename: "", length: "")
                                } label: {
                                    Text("Import Your Song Here")
                                }
                                .padding().foregroundColor(.black)
                                .buttonStyle(.bordered)
                                
                                Menu {
                                    Button {
                                        playlist.sortOption = .ascendingDate
                                        playlist.tracks.sort(sortOrder: playlist.sortOption)
                                    } label: {
                                        if playlist.sortOption == .ascendingDate {
                                            Label("Ascending Date", systemImage: "checkmark")
                                        } else {
                                            Text("Ascending Date")
                                        }
                                    }
                                    Button {
                                        playlist.sortOption = .descendingDate
                                        playlist.tracks.sort(sortOrder: playlist.sortOption)
                                    } label: {
                                        if playlist.sortOption == .descendingDate {
                                            Label("Descending Date", systemImage: "checkmark")
                                        } else {
                                            Text("Descending Date")
                                        }
                                    }
                                    Button {
                                        playlist.sortOption = .confidenceLevel
                                        playlist.tracks.sort(sortOrder: playlist.sortOption)
                                    } label: {
                                        if playlist.sortOption == .confidenceLevel {
                                            Label("Confidence Level", systemImage: "checkmark")
                                        } else {
                                            Text("Confidence Level")
                                        }
                                    }
                                } label: {
                                    Image(systemName: "arrow.up.arrow.down")
                                        .padding(6.5)
                                        .background(Color(UIColor.lightGray))
                                        .cornerRadius(10)
                                }
                                
                                // TODO: Replace deprecated NavigiationView with NavigationStack and new style of NavigationLink
                                NavigationLink(destination: NewButtonAction(),
                                               tag: 1,
                                               selection: $newButtonAction) {
                                    Button {
                                        newButtonAction = 1
                                    } label: {
                                        Text("New Button")
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
                                    Spacer()
                                    
                                    VStack {
                                        RecordButton(isRecording: $shazamSession.isRecording) {
                                            shazamSession.listenMusic(shouldRecognize: !shouldRecord) { url in
                                                do {
                                                    try upload(file: url)
                                                    print(url)
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                        }
                                        .alert(shazamSession.errorMsg,
                                               isPresented: $shazamSession.showError){
                                            Button("Close",role: .cancel){
                                            }
                                        }
                                        
                                        Toggle(isOn: $shouldRecord) {
                                            Text(shouldRecord ? "Live Recording" : "Recognize song")
                                        }
                                        .frame(width: 250)
                                    }
                                    
                                    Spacer()
                                    
                                    //                                    VStack {
                                    //                                        RecordButton(isRecording: $shazamSession.isRecording, filled: false) {
                                    //                                            shazamSession.listenMusic(shouldRecognize: false) { url in
                                    //                                                do {
                                    //                                                    let data = try Data(contentsOf: url)
                                    //                                                    //try upload(file: url, name: url.lastPathComponent,raga: printres(url: url) )
                                    //                                                    //try upload(file: url)
                                    //                                                    //upload(file: data, name: url.lastPathComponent, raga: printres(url: url))
                                    //                                                    print(url)
                                    //                                                } catch {
                                    //                                                    print(error)
                                    //                                                }
                                    //                                            }
                                    //                                        }
                                    //
                                    //                                        Text("Live Recording")
                                    //                                    }
                                }
                                
                                
                                
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
        userTracks.addDocument(data: ["song": name,
                                      "filePath": fileRef.fullPath,
                                      "date": Date() ]) {error in
            
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
        
        var songTitle = name
        if playlist.tracks.contains(where: { $0.title == songTitle }) {
            var index = 1
            while playlist.tracks.contains(where: { $0.title == songTitle + " (\(index)) " }) {
                index += 1
            }
            
            songTitle += " (\(index)) "
        }
        
        let ref = Storage.storage().reference()
        let fileRef = ref.child(uid).child(songTitle)
        let uploadTask = fileRef.putData(file, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to upload \(songTitle): \(error)")
            }
            print("Completed upload of \(songTitle)")
        }
        uploadTask.resume()
        //tracks for updating files vaishu
        let trackData: [String : Any] = ["song": songTitle,
                                         "filePath": fileRef.fullPath,
                                         "raga" : raga,
                                         "date" : Date()]
        
        userTracks.addDocument(data: trackData) {error in
            if let error = error {
                print("Failed to update \(songTitle): \(error)")
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
