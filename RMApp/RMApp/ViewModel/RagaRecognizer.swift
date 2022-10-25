//
//  RagaRecognizer.swift
//  RMApp
//
//  Created by Shakeer on 10/21/22.
//

import Foundation
import Swift
import CoreML




import AVFoundation
//import CoreML
// ...

func readWavIntoFloats(fname: String, ext: String) -> [Float] {

    let url = Bundle.main.url(forResource: fname, withExtension: ext)
    let file = try! AVAudioFile(forReading: url!)
    let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)!
    let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 15600)!
    try! file.read(into: buf)

    // this makes a copy, you might not want that
    let floatArray = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))

    return floatArray

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








func testModel()->SoundAnalysisPreprocessingOutput?
{
    
    let arr = readWavIntoFloats(fname: "asavari01", ext: "wav")

    
   
  
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

