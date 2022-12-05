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
        
        
        
        VStack{
            Text("Results").font(.system(size: 26)).position(x:200, y:-20).bold()

            Label("Possible Ragas: \n", systemImage: "music.note.list").font(.system(size: 35)).background(.clear, in: RoundedRectangle(cornerRadius: 1)).position(x:200, y:100)
                
                Text(ragastring).font(.system(size: 30)).background(.clear, in: RoundedRectangle(cornerRadius: 1)).position(x:200, y:-10)
            
            Text("Confidence Level: " + ragaAccuracy + "%").font(.system(size: 20)).background(.clear, in: RoundedRectangle(cornerRadius: 1)).position(x:200, y:-45).underline()
            
            
            
            
            
            HStack{ Button(action:{
                
                isSaving = true
                //semaphore.signal() //1
                
                JHomescreen().plssave()
                showPopup = true
                
            }
                           
                           
            )
                
                {Text("Save").frame(width: 200, height: 40)}
                    .frame(width: 100)
                    .padding().foregroundColor(.blue)
                    .buttonStyle(.bordered)
                    .alert(
                        isPresented : $showPopup){
                            Alert(
                                title: Text("File Saved"),
                                dismissButton: .default(Text("Ok"))
                                
                            )
                        }
                
            }
        }.background(LinearGradient(gradient: Gradient(colors: [.init(red: 0.67, green: 0.84, blue: 0.90), .init(red: 0.89, green: 0.84, blue: 0.90)]), startPoint: .top, endPoint: .bottom))
    }
    
}
    
    


struct NewButtonAction_Previews: PreviewProvider {
    static var previews: some View {
        NewButtonAction()
    }
    
}






