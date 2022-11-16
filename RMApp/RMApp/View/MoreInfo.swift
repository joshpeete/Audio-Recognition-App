//
//  MoreInfo.swift
//  RMApp
//
//  Created by Joshua Peete on 11/16/22.
//

import SwiftUI

struct MoreInfo: View {
    var body: some View {
        List{
            Section("More Information"){
                Link(destination: URL(string: "https://www.kennedy-center.org/education/resources-for-educators/classroom-resources/media-and-interactives/media/international/rhythm-and-raga/")!) {
                    VStack {
                        Text("What is a Raga?")
                    }
                }
            }
        }
    }
}

struct MoreInfo_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfo()
    }
}
