//
//  NewButtonAction.swift
//  RMApp
//
//  Created by Vaishnavi Nannur on 11/13/22.
//

import SwiftUI





struct NewButtonAction: View {
    
    @State var ragastring = Ragastring
    @State var ragaAccuracy = RagaAccuracy
    @State var showPopup = false
    
    //let succesfulAction: () -> Void
    
    var body: some View {
        
        
        
        
        
        Label("Raga: " + ragastring, systemImage: "music.note.list").font(.system(size: 40)).background(.white, in: RoundedRectangle(cornerRadius: 1))
        
        Text("Confidence Level: " + ragaAccuracy + "%").font(.system(size: 20)).background(.white, in: RoundedRectangle(cornerRadius: 1))
        
        
        
        
        
        HStack{ Button(action:{
            
            isSaving = true
            //semaphore.signal() //1
           
            JHomescreen().plssave()
            showPopup = true

        }
            
        
        )
            
            {Text("Save")}
                .padding().foregroundColor(.black)
                .buttonStyle(.bordered)
                .alert(
                    isPresented : $showPopup){
                        Alert(
                            title: Text("File Saved"),
                            dismissButton: .default(Text("Ok"))
                        
                        )
                    }
            
        }

        
        
        
        
        
    }
    
}
    


struct NewButtonAction_Previews: PreviewProvider {
    static var previews: some View {
        NewButtonAction()
    }
    
}






