//
//  Playlist.swift
//  RMApp
//
//  Created by Vaishnavi Nannur on 10/22/22.
//

import Foundation
import FirebaseFirestore
import Firebase

class Playlist: ObservableObject {
    static let instance = Playlist()
    @Published var tracks: [Track] = []
    
    func update() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userTracks = Firestore.firestore().collection("users").document(uid).collection("tracks")
        
        Task {
            var tracks: [Track] = []
            do {
                let trackList = try await userTracks.getDocuments().documents
                for json in trackList {
                    if let path = json["filePath"] as? String, let title = json["song"] as? String {
                        tracks.append(Track(title: title,
                                            artist: "",
                                            artwork: URL(fileURLWithPath: ""),
                                            appleMusicURL: URL(fileURLWithPath: ""),
                                            path: path))
                    }
                }
                
                let foundTracks = tracks
                await MainActor.run {
                    self.tracks = foundTracks
                }
            } catch {
                print("Error when fetching tracks: \(error)")
            }
        }
    }
}
