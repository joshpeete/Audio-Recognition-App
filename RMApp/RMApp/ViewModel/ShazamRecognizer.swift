//SHAZAMKIT FUNCS AND SETUP
//  SwiftUIView.swift
//  RMApp
//
//  Created by Joshua Peete on 10/18/22.
//

import SwiftUI
import ShazamKit
import AVKit

class ShazamRecognizer: NSObject, ObservableObject, SHSessionDelegate{
    @Published var session = SHSession()
    @Published var audioEngine = AVAudioEngine()
    @Published var errorMsg = ""
    @Published var showError = false
    @Published var isRecording = false
    
    //Found Track
    @Published var matchedTrack: Track!
    
    override init(){
        super.init()
        session.delegate = self
    }
    
    func session( _ session: SHSession, didFind match: SHMatch){
        //Match Found
        if let firstItem = match.mediaItems.first{
            //Shows what song is being recognized in the output window
            DispatchQueue.main.async {
                self.matchedTrack = Track(title: firstItem.title ?? "", artist: firstItem.artist ?? "", artwork: firstItem.artworkURL ?? URL(string: "")!, appleMusicURL: firstItem.appleMusicURL ?? URL(string: "")!)
            }
        }
    }
    
    func session( _ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?){
        //No Match
        DispatchQueue.main.async {
            self.errorMsg = "\(error!)"
            self.showError.toggle()
            //stopping audio recording
            self.stopRecording()
        }
    }
    
    func stopRecording(){
        audioEngine.stop()
        withAnimation{
            isRecording = false
        }
    }
    
    
    //Fetch Music
    func listenMusic(){
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission{ status in
            
            if status{
                self.recordAudio()
            }
            else{
                self.errorMsg = "Please Allow Microphone Access"
                self.showError.toggle()
            }
        }
    }
    
    func recordAudio(){
        //if already recording...stop
        if audioEngine.isRunning{
            self.stopRecording()
            return
        }
        //recording Audio
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: .zero)
        
        //removing if already installed
        inputNode.removeTap(onBus: .zero)
        
        //instslling when you tap the button
        inputNode.installTap(onBus: .zero, bufferSize: 1024, format: format){ buffer, time in
            
          //ShazamKit Session Start
            self.session.matchStreamingBuffer(buffer, at: time)
        }
        //starting audio matching
        audioEngine.prepare()
        
        do{
            try audioEngine.start()
            print("Starting")
            withAnimation{
                self.isRecording = true
            }
        }
        catch{
            self.errorMsg = error.localizedDescription
            self.showError.toggle()
        }
    }
}



