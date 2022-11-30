//
//  MoreInfo.swift
//  RMApp
//
//  Created by Joshua Peete on 11/16/22.
//

import SwiftUI

struct MoreInfo: View {
    var body: some View {
        //List that holds the two seperate sections, article and video
        List{
            Section("More Information"){
                Link(destination: URL(string:  "https://www.kennedy-center.org/education/resources-for-educators/classroom-resources/media-and-interactives/media/international/rhythm-and-raga/")!) { //link to article
                    VStack {
                        Text("What is a Raga?")
                    }
                }
            }
            }
        YoutubeView(videoID: "xugP5eNqodQ?t=9") //embedded code marker from Youtube
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9, maxHeight: UIScreen.main.bounds.height * 0.3) //from Get Rect equation
                .cornerRadius(12)
                .offset(y:-350)
        }
    }



struct MoreInfo_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfo()
    }
}
