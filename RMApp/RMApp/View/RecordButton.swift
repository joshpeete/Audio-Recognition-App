//
//  RecordButton.swift
//  RMApp
//
//  Created by Vaishnavi Nannur on 11/11/22.
//
import SwiftUI

struct RecordButton: View {
    @Binding var isRecording: Bool
    @State var filled = true
    @State var recordAction: () -> Void
    
    var stopImage: String {
        filled ? "stop.circle.fill" : "stop.circle"
    }
    
    var startImage: String {
        filled ? "mic.circle" : "mic.circle.fill"
    }
    
    var body: some View {
        Button{
            recordAction()
        }label: {
            Image(systemName: isRecording ? stopImage : startImage)
                .foregroundColor(.black)
                .font(.system(size: 150))
                .ignoresSafeArea()
        }
    }
}

struct RecordButton_Previews: PreviewProvider {
    @State static var isRecording = false
    
    static var previews: some View {
        RecordButton(isRecording: $isRecording) {
            isRecording.toggle()
        }
    }
}
