//
//  DetailView.swift
//  RMApp
//
//  Created by Vaishnavi Nannur on 11/3/22.
//

import SwiftUI
import AVFoundation
import Firebase
import FirebaseStorage
import UIKit
import MobileCoreServices
import FirebaseFirestore


struct DetailView: View {
    @ObservedObject var playlist = Playlist.instance
    @State var flag = false
    @State var ragaData = ""
    @State var audioPlayer: AVAudioPlayer? = nil
    @State var track: Playlist.Track
    @FocusState var isFocused: Bool
    @State private var listItemsD = ["","",""]

    //var track: Playlist.Track
    
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
    
    func MakeRaga()-> Void{
        var temporaryraga = track.raga
        listItemsD = temporaryraga.components(separatedBy: ", ")
    }
    var body: some View {
        VStack{
            
                TextField(text: $track.title) {
                    EmptyView()
                }.font(.system(size: 20))
                    .frame(width: 255)
                    .multilineTextAlignment(.center)
                    .focused($isFocused)
                    .padding()
                    .foregroundColor(.blue)
                    .border(.black, width: 4)
                    .onChange(of: isFocused) { _ in
                        print(isFocused ? "Focused" : "Not Focused")
                    }
                    .onSubmit {
                        print("Submit")
                        updateTrack()
                    }
            
        
        Label("Possible Ragas: \n", systemImage: "music.note.list").font(.system(size: 35)).background(.clear, in: RoundedRectangle(cornerRadius: 1)).position(x:200, y:228)
            
            Text(track.raga).font(.system(size: 30)).background(.clear, in: RoundedRectangle(cornerRadius: 1)).position(x:200, y:100)
        
            Text("Confidence Level: " + track.accuracy + "%").font(.system(size: 20)).background(.clear, in: RoundedRectangle(cornerRadius: 1)).position(x:200, y:40).underline()
        
        HStack{
            Button(action:{
                play(soundWithPath: track.path)
            })
            {Image(systemName:"play.fill").frame(width: 75, height: 40)}
                .padding()
                .buttonStyle(.bordered)
                .frame(width: 100)
            
            Button(action:{
                pause(soundWithPath: track.path)
            })
            {Image(systemName:"stop.fill").frame(width: 75, height: 40)}
                .padding()
                .buttonStyle(.bordered)
                
        }.position(x:200, y:100)
        
    }.background(LinearGradient(gradient: Gradient(colors: [.init(red: 0.67, green: 0.84, blue: 0.90), .init(red: 0.89, green: 0.84, blue: 0.90)]), startPoint: .top, endPoint: .bottom))
        
    }
    func updateTrack() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userTracks = Firestore.firestore().collection("users").document(uid).collection("tracks")
        
        print("\(track.title) \(track.date ?? Date()) \(track.id)")
        print(track.id)

        userTracks.document(track.id).updateData([
            "song": track.title
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                Playlist.instance.update()
            }
        }
    }
    func getRagaData(path: String) {
        DownloadManager.instance.download(filePath: path) { data, error in
            guard let data = data else {
                if let error = error {
                    print("Failed to download \(path): \(error)")
                } else {
                    print("Failed to download: reason unknown")
                }
                
                return
            }
            
            do {
                var url = try FileManager.default.url(for: .documentDirectory,
                                                      in: .userDomainMask,
                                                      appropriateFor: nil,
                                                      create: true)
                
                let name = "TempAudioFile.wav"
                url = url.appending(component: name)
                
                try data.write(to: url)
                
                return;
                
                let result = printres(url: url)
                if let result = result {
                    if result.count == 0 {
                        self.ragaData = "no raga found"
                    } else {
                        self.ragaData = result
                    }
                } else {
                    self.ragaData = "no raga found"
                }
            } catch {
                print(error)
            }
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(track: Track(title: "",
//                                artist: "",
//                                artwork: URL(fileURLWithPath: ""),
//                                appleMusicURL: URL(fileURLWithPath: ""),
//                                path: ""))
//    }
//}
