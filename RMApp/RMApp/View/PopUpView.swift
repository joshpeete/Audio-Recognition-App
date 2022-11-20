//
//  PopUpView.swift
//  RMApp
//
//  Created by Shakeer on 11/17/22.
//

import SwiftUI

struct PopUpView: View {
    var body: some View {
        
        Text("Saved")
            .font(.system(.largeTitle,design:.rounded).bold())
        
            .padding()
            .background(Color.gray)
            
        
    }
}

struct PopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView()
    }
}
