//
//  AudioNav.swift
//  RMApp
//
//  Created by Vaishnavi Nannur on 11/3/22.
//

import SwiftUI



struct AudioNav: View {
    var tracks = [""]
    var body: some View {
        //NavigationView {
            List(tracks, id: \.self) { track in
//                NavigationLink(
//                    destination: Text("hello"),
//                    label: {
                        AudioListView(title: track)

       //             })
                
            }
    //    }.background(Color.clear)
            
    }
}

struct AudioNav_Previews: PreviewProvider {
    static var previews: some View {
        AudioNav()
    }
}
