//
//  SKView.swift
//  RMApp
//
//  Created by Joshua Peete on 10/16/22.
//

import SwiftUI
import AVKit
import ShazamKit

class ShazamRecognizer: NSObject, ObservableObject, SHSessionDelegate{
   
    private var audioEngine = AVAudioEngine()
    private var session = SHSession()
    
    override init() {
        super.init()
        session.delegate = self
    }
    
    func session( session: SHSession: SHSession, didFind match: SHMatch){
        //Match Found
        if let firstItem = match.mediaItems.first{
            print(firstItem.title ?? "")
        }
    }

    func session( session: SH
}


extension ContentViewModel: SHSessionDelegate {
    func session(_ session: SHSession, didFind match: SHMatch) {
        let mediaItems = match.mediaItems
        if let firstItem = mediaItems.first {
            let _shazamMedia = ShazamMedia(title: firstItem.title,
                                           subtitle: firstItem.subtitle,
                                           artistName: firstItem.artist,
                                           albumArtURL: firstItem.artworkURL,
                                           genres: firstItem.genres)
            DispatchQueue.main.async {
                self.shazamMedia = _shazamMedia
            }
        }
    }
}

