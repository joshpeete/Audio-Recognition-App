//
//  AudioListView.swift
//  RMApp
//
//  Created by Vaishnavi Nannur on 11/3/22.
//

import SwiftUI

struct AudioListView: View{
    
    var title: String
    
    var body: some View {
        HStack{
//            Image(video.imageName)
//                .resizable()
//                .scaledToFit()
//                .frame(height: 70)
//                .cornerRadius(4)
//                .padding(.vertical,4)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                
//                Text(video.uploadDate)
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
                
            }
        }
    }
}

struct AudioListView_Previews: PreviewProvider {
    static var previews: some View {
        AudioListView(title: "Hello")
    }
}
