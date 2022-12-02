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

    var track: Playlist.Track
    
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
        Text("\(track.title)")
            .padding()
            .foregroundColor(.black)
            .border(.black, width: 4).position(x:200, y:50)
        
        Label("Raga: " + track.raga, systemImage: "music.note.list").font(.system(size: 40)).background(.white, in: RoundedRectangle(cornerRadius: 1)).position(x:200, y:100)
        
        Text("Confidence Level: " + track.accuracy + "%").font(.system(size: 20)).background(.white, in: RoundedRectangle(cornerRadius: 1)).position(x:200, y:-50)
        
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
