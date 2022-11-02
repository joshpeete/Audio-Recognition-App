//
//  RagaRecognizer.swift
//  RMApp
//
//  Created by Shakeer on 10/21/22.
//

import Foundation
import Swift
import CoreML
import Firebase
import AVFoundation
import FirebaseStorage

//let pathReference = storage.reference(withPath: "gs://raga-mania-7d2bb.appspot.com/mxaVaOWXlCVbLBRwVXMwpOLKWww2/asavari03.wav")
//
//let localURL = URL(string: "mxaVaOWXlCVbLBRwVXMwpOLKWww2/asavari03.wav")!

// Create a reference to the file you want to download





func playTest(soundWithPath path: String) {
    
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



//func readWavIntoFloats(soundWithPath path: String) -> [Float] {
//
//    var emptyFloats: Array<Float> = Array()
//    var floatArray: Array<Float> = Array()
//
//    DownloadManager.instance.download(filePath: path) {data, error in
//        print("Download of \(path) complete")
//
//
//
////           let url = Bundle.main.url(forResource: "asavari01", withExtension: "wav")
////            let file = try! AVAudioFile(forReading: url!)
//
//        let url = Bundle.main.url(forResource: "asavari01", withExtension: "wav")
//         let file = try! AVAudioFile(forReading: url!)
//
//
//
//            let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)!
//            let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 15600)!
//            try! file.read(into: buf)
//
//            // this makes a copy, you might not want that
//           var floatArray = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))
//
////        return emptyFloats
//
//
//    }
//    return floatArray
//
//}

// "file:///Users/umairahmed/Library/Developer/CoreSimulator/Devices/DDDB660D-7B43-4AF8-A808-18EB6387B068/data/Containers/Bundle/Application/A2BC2D05-6160-4B00-8266-B142E9014918/RMApp.app/asavari01.wav"

func readWavIntoFloats(fname: String, ext: String) -> [Float] {
    
//    let storageRef = Storage.storage().reference(withPath: "mxaVaOWXlCVbLBRwVXMwpOLKWww2/asavari03.wav")
//    storageRef.getData(maxSize: 4 * 1024 * 1024) {(data, error) in
//
//        if let error = error{
//            print("error")
//            return
//        }
//        if let data = data{
//            let music = data
//        }
//        print(type(of: data))
//    }
    
    let url = Bundle.main.url(forResource: fname, withExtension: ext)
    let file = try! AVAudioFile(forReading: url!)
    let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)!
    let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 15600)!
    try! file.read(into: buf)

    // this makes a copy, you might not want that
    let floatArray = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))

    return floatArray

}

//func readWavIntoFloats1() -> [Float] {
//
//    let islandRef = storageRef.child("images/island.jpg")
//
//
//
//    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//    islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
//      if let error = error {
//        // Uh-oh, an error occurred!
//      } else {
//        // Data for "images/island.jpg" is returned
//        let music = UIImage(data: data!)
//
//      }
//    }
//
//    let url = Bundle.main.url(music)
//    let file = try! AVAudioFile(forReading: url!)
//    let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)!
//    let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 15600)!
//    try! file.read(into: buf)
//
//    // this makes a copy, you might not want that
//    let floatArray = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))
//
//    return floatArray
//
//}
//func createWavFile(using rawData: Data) throws -> URL {
//           //Prepare Wav file header
//           let waveHeaderFormate = createWaveHeader(data: rawData) as Data
//
//           //Prepare Final Wav File Data
//           let waveFileData = waveHeaderFormate + rawData
//
//           //Store Wav file in document directory.
//           return try storeMusicFile(data: waveFileData)
//       }

//func storeMusicFile(data: Data) {
//     let fileName = "Record-1"
//     guard DocumentDirectoryURL != nil else {
//           print("Error: Failed to fetch mediaDirectoryURL")
//           return
//     }
//
//     let filePath = mediaDirectoryURL!.appendingPathComponent("/\(fileName).mp3")
//     do {
//        try data.write(to: filePath, options: .atomic)
//     } catch {
//        print("Failed while storing files.")
//     }
//}

func printStuff(){
    let storageRef = Storage.storage().reference(withPath: "mxaVaOWXlCVbLBRwVXMwpOLKWww2/asavari03.wav")
    var music = Data(count: 12)
    //let storageRef = Storage.storage().reference(withPath: "Gdh5rCXVtANytKA3i2onaiiR0Xs1/Blinding Lights (The Weeknd Lofi Cover).wav")
    
    storageRef.getData(maxSize: 100 * 1024 * 1024) {(data, error) in
        
        if let error = error{
            print("error")
            return
        }
        if let data = data{
            
           var music = data
            
        }
        //print(type(of: data))
        let stringInt = String.init(data: data!, encoding: String.Encoding.utf8)
        let int1 = Int.init(stringInt ?? "")
        print(data)
       
    }
    
}




func convertToMLMultiArray(from array: [Float]) -> MLMultiArray {
    let length = NSNumber(value: array.count)

    
    // Define shape of array
    guard let mlMultiArray = try? MLMultiArray(shape:[length], dataType:MLMultiArrayDataType.float32) else {
        fatalError("Unexpected runtime error. MLMultiArray")
    }
    
    // Insert elements
    for (index, element) in array.enumerated() {
        mlMultiArray[index] = NSNumber(floatLiteral: Double(element))
    }
    
    return mlMultiArray
}




//"Gdh5rCXVtANytKA3i2onaiiR0Xs1/Blinding Lights (The Weeknd Lofi Cover).wav"



func testModel()->SoundAnalysisPreprocessingOutput?
{
    
    let arr = readWavIntoFloats(fname: "asavari01", ext: "wav")
//    let arr = readWavIntoFloats(soundWithPath: "Gdh5rCXVtANytKA3i2onaiiR0Xs1/Blinding Lights (The Weeknd Lofi Cover).wav")

    
   
  
    let multi = convertToMLMultiArray(from: arr)
    
    
    do{
        
        let config = MLModelConfiguration()
        let model = try SoundAnalysisPreprocessing(configuration: config)
        let prediction = try model.prediction(audioSamples: multi)
        
        
        return prediction
    }
    catch{
        
    }
    
    
    return nil
}




func testModel2()->MLModelRnnOutput?
{
    let multi = testModel()!.preprocessedAudioSamplesShapedArray
    
   // let multi = try MLMultiArray(shape: [1,96,64,1], dataType: MLMultiArrayDataType.float32)
    
    do{
        let config = MLModelConfiguration()
        let model = try MLModelRnn(configuration: config)
        let prediction = try model.prediction(lstm_3_input: multi)
    
        return prediction
        
    } catch{
        
       
    }
    
    return nil
    
}



func printres()->String!{
    let pred = testModel()!.preprocessedAudioSamples
   
    let pred3 = testModel()!.preprocessedAudioSamplesShapedArray
    let pred4 = testModel()!.self
    
    
    let ohgod=testModel2()!.IdentityShapedArray
    
   
    
    //print(ohgod)
    
    
    
    
    var singlresult = ohgod.scalars
    
    let raganames = [0: "Asavari", 1: "Bageshree" , 2: "Bhairavi", 3: "Bhoop", 4: "Bhoopali",
                     5: "Darbari", 6: "Dkanada", 7: "Malkauns" , 8 : "Sarang", 9: "Yaman" , 10: "Unknown"]
    
    
   
    let maxpred = singlresult.max()
    
    
    let idx = singlresult.index(of:maxpred!)
    
    var myIntValue = Int(idx!)
    
    //print(singlresult)
    
    let finalOutput:String! = raganames[myIntValue]!
    return finalOutput
    
}

