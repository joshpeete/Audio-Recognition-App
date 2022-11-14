//SHAZAMKIT FUNCS AND SETUP
//  SwiftUIView.swift
//  RMApp
//
//  Created by Joshua Peete on 10/18/22.
//

import SwiftUI
import ShazamKit
import AVKit

typealias RecordingCompletion = (URL) -> Void

class ShazamRecognizer: NSObject, ObservableObject, SHSessionDelegate{
    @Published var session = SHSession()
    @Published var audioEngine = AVAudioEngine()
    @Published var errorMsg = ""
    @Published var showError = false
    @Published var isRecording = false
    @Published var isListening = false
    var recordingCompletion: RecordingCompletion? = nil
    var file: AVAudioFile? = nil
    var recognize: Bool = true
    
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
                self.matchedTrack = Track(title: firstItem.title ?? "",
                                          artist: firstItem.artist ?? "",
                                          artwork: firstItem.artworkURL,
                                          path: "")
                
                self.callCompletion()
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
    //ur mom
    func stopRecording(){
        audioEngine.stop()
        withAnimation{
            isRecording = false
            isListening = false
        }
        self.callCompletion()
    }
    
    func callCompletion() {
        guard let file = file else { return }
        
        recordingCompletion?(file.url)
        recordingCompletion = nil
        
        do {
            try FileManager.default.removeItem(at: file.url)
            self.file = nil
        } catch {
            print(error)
        }
    }
    
    //Fetch Music
    func listenMusic(shouldRecognize: Bool, completion: RecordingCompletion? = nil){
        recordingCompletion = completion
        recognize = shouldRecognize
        
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
        inputNode.installTap(onBus: .zero, bufferSize: 1024, format: format){ [weak self] (buffer, time) in
            //ShazamKit Session Start
            if self?.recognize == true {
                self?.session.matchStreamingBuffer(buffer, at: time)
            } else {
                do {
                    if self?.file == nil {
                        var url = try FileManager.default.url(for: .documentDirectory,
                                                              in: .userDomainMask,
                                                              appropriateFor: nil,
                                                              create: true)
                        
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .medium
                        let name = dateFormatter.string(from: Date()) + ".wav"
                        
                        url = url.appendingPathComponent(name)
                        
                        let bufferFormat = buffer.format
                        
                        self?.file = try AVAudioFile(forWriting: url,
                                                     settings: bufferFormat.settings,
                                                     commonFormat: bufferFormat.commonFormat,
                                                     interleaved: bufferFormat.isInterleaved)
                    }
                    
                    try self?.file?.write(from: buffer)
                } catch {
                    print(error)
                }
                //self?.file = try AVAudioFormat( sampleRate: Float32,
                //layout: 1)
            }
        }
        //starting audio matching
        audioEngine.prepare()
        
        do{
            try audioEngine.start()
            print("Starting")
            withAnimation{
                DispatchQueue.main.async {
                    if self.recognize {
                        self.isListening = true
                    } else {
                        self.isRecording = true
                    }
                }
            }
        }
        catch{
            self.errorMsg = error.localizedDescription
            self.showError.toggle()
        }
    }
}



