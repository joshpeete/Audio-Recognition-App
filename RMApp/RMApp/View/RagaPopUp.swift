//
//  RagaPopUp.swift
//  RMApp
//
//  Created by Shakeer on 11/8/22.
//

import SwiftUI


struct RagaPopUp: View {
    
    
    var body: some View {
        
        
        
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        VStack{
            
//            Label(JHomescreen.JustRaga, systemImage: "music.note.list").font(.system(size: 20)).background(.white, in: RoundedRectangle(cornerRadius: 1))
            
            
            
            Label("Hello", systemImage: "music.note.list").font(.system(size: 20)).background(.white, in: RoundedRectangle(cornerRadius: 1))
            
            
            
            
            Button(action:{
                //isImporting.toggle()
                //self.addData(filename: "", length: "")
                
//                                    NavigationLink("RagaPopUp", destination: RagaPopUp())
                //JHomescreen.HomeFlag = true
                
            })
                {Text("Back")}
                    .padding().foregroundColor(.black)
                    .buttonStyle(.bordered)
            
            
            
            
//            NavigationView{
//                if JHomescreen.HomeFlag{
//                    JHomescreen()
//                }
//            }
            
            
            //
            //            Button( {action:{ JHomescreen(DoSave: true)}
            //
            //            }
            
//            Button("Save", action:{JHomescreen.DoSave.toggle()
//
//            })
            
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
}

struct RagaPopUp_Previews: PreviewProvider {
    static var previews: some View {
        RagaPopUp()
    }
}
