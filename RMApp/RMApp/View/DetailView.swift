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
    @State var track: Track
    @FocusState var isFocused: Bool
    
    func play(soundWithPath path: String) {
        DownloadManager.instance.download(filePath: path) { data, error in
            print("Download of \(path) complete")
            if let data = data {
                audioPlayer = try? AVAudioPlayer(data: data)
                audioPlayer?.play()
            } else if let error = error {
                print("Failed to download \(path): \(error)")
            }
        }
    }
    
//    func play(data: Data?) {
//        if let data = data {
//            audioPlayer = try? AVAudioPlayer(data: data)
//            audioPlayer?.play()
//        }
//    }
    
    //this func allows the uploaded file to be paused - Josh
    func pause(soundWithPath path: String) {
        audioPlayer?.pause()
    }
    
    //    //vaishu - upload
    //    func upload(file: Data, name: String) -> String {
    //        guard let uid = Auth.auth().currentUser?.uid else { return "" }
    //        let userTracks = Firestore.firestore().collection("users").document(uid).collection("tracks")
    //
    //        let ref = Storage.storage().reference()
    //        let fileRef = ref.child(uid).child(name)
    //        let uploadTask = fileRef.putData(file, metadata: nil) { metadata, error in
    //            if let error = error {
    //                print("Failed to upload \(name): \(error)")
    //            }
    //            print("Completed upload of \(name)")
    //        }
    //        uploadTask.resume()
    //        //tracks for updating files vaishu
    //        userTracks.addDocument(data: ["song": name, "filePath": fileRef.fullPath]) {error in
    //
    //            if let error = error {
    //                print("Failed to update \(name): \(error)")
    //            } else {
    //                self.playlist.update()
    //            }
    //        }
    //        return fileRef.fullPath
    //    }
    //vaishu adding data
    //    func addData(filename: String, length: String){
    //        let db = Firestore.firestore()
    //        db.collection("sample").addDocument(data: ["song": filename, "length": length]){error in
    //            if error == nil {
    //            }
    //        }
    //    }
    
    var body: some View {
        TextField(text: $track.title) {
            EmptyView()
        }
        .focused($isFocused)
        .padding()
        .foregroundColor(.black)
        .border(.black, width: 4)
        .onChange(of: isFocused) { _ in
            print(isFocused ? "Focused" : "Not Focused")
        }
        .onSubmit {
            print("Submit")
            updateTrack()
        }
        
        HStack{
            Button(action:{
                 play(soundWithPath: track.path)
                //play(data: try? Data(contentsOf: URL(fileURLWithPath: track.path)))
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
        Label("Raga: " + track.raga, systemImage: "music.note.list").font(.system(size: 20)).background(.white, in: RoundedRectangle(cornerRadius: 1))
        Text(ragaData)
            .onAppear {
                getRagaData(path: track.path)
            }
    }
    
    func updateTrack() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userTracks = Firestore.firestore().collection("users").document(uid).collection("tracks")
        
        print("\(track.title) \(track.date ?? Date()) \(track.id)")

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
