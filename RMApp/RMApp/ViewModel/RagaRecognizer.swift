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

public var maxpred: Float  = 0

func readWavIntoFloats(filepath: URL) -> [Float] {
   var floatArray:[Float] = []
    
    let file = try! AVAudioFile(forReading: filepath)
    var format = AVAudioFormat()
    
    if(file.fileFormat.channelCount == 1){
        print("one channel")
        format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)!
    }
    else{
        print("two channels")
        format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 2, interleaved: false)!}
    
   
    let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 15600)!
    try! file.read(into: buf)

    // this makes a copy, you might not want that
    floatArray = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))

    while(floatArray.count < 15600){
        floatArray.append(Float(0))
    }
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

    }
    return nil
}

func testModel2(url:URL)->ThirtyTimeOutput?
{
    let multi = testModel(url: url)!.preprocessedAudioSamplesShapedArray
    
    do{
        let config = MLModelConfiguration()
        let model = try ThirtyTime(configuration: config)
        let prediction = try model.prediction(lstm_input: multi)
    
        return prediction
        
    } catch{

    }
    return nil
}



func printres(url:URL)->String!{
    var idx = 10;
    var idx2 = 10;
    var idx3 = 10;
    maxpred = 0;
    
    let ohgod=testModel2(url: url)!.IdentityShapedArray
    var singlresult = ohgod.scalars
    
    var ragaArray  = String()

    var raganames = [0: "Asavari", 1: "Bageshree" , 2: "Bhairavi", 3: "Bhoop", 4: "Bhoopali",
                     5: "Darbari", 6: "Dkanada", 7: "Malkauns" , 8 : "Sarang", 9: "Yaman" , 10: "Can't Recognize Raga!"]

    //maxpred is for confidence level
   // maxpred = singlresult.max() ?? -1
    print(singlresult)
    
    let fmax = singlresult.max()
    idx = singlresult.index(of:fmax!) ?? 10
    maxpred += singlresult[idx]
    ragaArray.append(raganames[idx] ?? "ER")
    ragaArray.append(", ")
    print("first:")
    print(fmax)
    singlresult[idx] = -1
    

    let smax = singlresult.max()
    idx2 = singlresult.index(of:smax!) ?? 10
    maxpred += singlresult[idx2]
    ragaArray.append(raganames[idx2] ?? "ER")
    ragaArray.append(", ")
    print("second:")
    print(smax)
    singlresult[idx2] = -1
    
    let tmax = singlresult.max()
    idx3 = singlresult.index(of:tmax!) ?? 10
    maxpred += singlresult[idx3]
    ragaArray.append(raganames[idx3] ?? "ER")
    print("third:")
    print(tmax)
   
    return ragaArray


}



func printAcc()->String!{
    var roundednum = round(maxpred * 100)

    if(roundednum == 300){roundednum = 30.0}
    let maxstring = String(roundednum)
    return maxstring
}
