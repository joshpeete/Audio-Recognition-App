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
    @Published var sortOption = SortOptions.ascendingDate

    struct Track: Identifiable {
        var id = UUID().uuidString
        let path: String
        var title: String
        let raga: String
        let accuracy: String
        var date: Date? = nil
        
    }

    func update() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userTracks = Firestore.firestore().collection("users").document(uid).collection("tracks")

        Task {
            var tracks: [Track] = []
            do {
                let trackList = try await userTracks.getDocuments().documents
                for json in trackList {
                    if let path = json["filePath"] as? String, let title = json["song"] as? String, let raga = json["raga"] as? String,let accuracy = json["accuracy"] as? String{
                        tracks.append(Track(id: json.documentID, path: path, title: title, raga: raga, accuracy: accuracy, date: (json["date"] as? Timestamp)?.dateValue()
))
                    }
                }
                
                tracks.sort(sortOrder: sortOption)

                let foundTracks = tracks
                await MainActor.run {
                    self.tracks = foundTracks
                }
            } catch {
                print("Error when fetching tracks: (error)")
            }
        }
    }
}

extension Array where Element == Playlist.Track{
    mutating func sort(sortOrder: SortOptions = .ascendingDate){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        func date(for track: Playlist.Track) -> Date {
            if let tmp = track.date {
                return tmp
            } else {
                var title = track.title
                if title.hasSuffix(".wav") {
                    title.removeLast(4)
                }
                
                if let tmp = dateFormatter.date(from: title) {
                    return tmp
                }
            }
            return Date(timeIntervalSince1970: 0)
        }
        
        
        self.sort { track1, track2 in
            switch sortOrder {
            case .ascendingDate:
                return date(for: track1) < date(for: track2)
            case .descendingDate:
                return date(for: track1) > date(for: track2)
            }
        }
        
        
        
    }
}
