//
//  RagaRecognizer.swift
//  RMApp
//
//  Created by Shakeer on 10/21/22.
//

import Foundation
import Swift
import CoreML
import FirebaseStorage




import AVFoundation



//import CoreML
// ...

//func readWavIntoFloats(fname: String, ext: String) -> [Float] {
//
//    let url = Bundle.main.url(forResource: fname, withExtension: ext)
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

func readWavIntoFloats(filepath: URL) -> [Float] {

    //let url = Bundle.main.url(forResource: fname, withExtension: ".wav")
    //let storage = Storage.storage()
    //let storageRef = storage.reference(forURL: filepath)
    //let url = String(storageRef)

//    let local = URL(string: "file://Users/shakeer/Desktop/Working/RMApp/RMApp/ViewModel/asavari01.wav")
//
   var floatArray:[Float] = []

//    let downloadTask = storageRef.write(toFile: local!) { url, error in
//      if let error = error {
//        // Uh-oh, an error occurred!
//          print(error)
//      } else {
//        // Local file URL for "images/island.jpg" is returned
//          print("itworked")
//
//      }
//    }


//        DownloadManager.instance.download(filePath: filepath) { data, error in
//            print("Download of \(filepath) complete")
//            if let data = data {
//                let url = URL(fileURLWithPath: storageRef)
//                let file = try! AVAudioFile(forReading: url)
//                let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)!
//                    let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 15600)!
//                    try! file.read(into: buf)
//
//                //     this makes a copy, you might not want that
//                    floatArray = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))
//            } else if let error = error {
//                print("Failed to download \(filepath): \(error)")
//
//            }
//        }
//



//    storageRef.downloadURL{ url, error in
//        if let error = error {
//          // Handle any errors
//            print("You messed up")
//        } else {
//          // Get the download URL for 'images/stars.jpg'
//            let file = try! AVAudioFile(forReading: url!)
//            let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)!
//            let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 15600)!
//            try! file.read(into: buf)
//            floatArray = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))
//


//
//        }
//      }


   // let url = URL(string: "gs://raga-mania-7d2bb.appspot.com/gL1KgkmytfUuQZa5q3fAoXTMcIA3/StarWars3.wav")

    //let fileUrl = URL(fileURLWithPath: url)
   // let url = URL(fileURLWithPath: storageRef)
    let file = try! AVAudioFile(forReading: filepath)
    let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)!
    let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 15600)!
    try! file.read(into: buf)

    // this makes a copy, you might not want that
    floatArray = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))

    //print(floatArray)
    return floatArray

    //print(floatArray)

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








func testModel(url:URL)->SoundAnalysisPreprocessingOutput?
{

    //let arr = readWavIntoFloats(fname: "asavari01", ext: "wav")
    let arr = readWavIntoFloats(filepath: url)




    let multi = convertToMLMultiArray(from: arr)


    do{

        let config = MLModelConfiguration()
        let model = try SoundAnalysisPreprocessing(configuration: config)
        let prediction = try model.prediction(audioSamples: multi)

        return prediction
    }
    catch{
        print(error)
    }


    return nil
}




func testModel2(url:URL)->MLModelRnnOutput?
{
    guard let multi = testModel(url: url)?.preprocessedAudioSamplesShapedArray else {
        return nil
    }
    
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



func printres(url:URL)->String!{
    var idx = 10;
//    let pred = testModel()!.preprocessedAudioSamples
//
//    let pred3 = testModel()!.preprocessedAudioSamplesShapedArray
//    let pred4 = testModel()!.self
    
    
    guard let ohgod=testModel2(url: url)?.IdentityShapedArray else {
        return ""
    }
    
   
    
    //print(ohgod)
    
    
    
    
    var singlresult = ohgod.scalars
    
    let raganames = [0: "Asavari", 1: "Bageshree" , 2: "Bhairavi", 3: "Bhoop", 4: "Bhoopali",
                     5: "Darbari", 6: "Dkanada", 7: "Malkauns" , 8 : "Sarang", 9: "Yaman" , 10: "Can't Recognize Raga!"]
    
    
   
    let maxpred = singlresult.max()
    
        
        
    
    if (maxpred! > Float(0.1)){
        idx = singlresult.index(of:maxpred!) ?? 10}
   
    
    var myIntValue = Int(idx)
    
    //print(singlresult)
    
    let finalOutput:String! = raganames[myIntValue]!
    print(finalOutput!)
    print(singlresult)
    return finalOutput
  
    
}
