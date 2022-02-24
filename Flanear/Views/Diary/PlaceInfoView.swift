//
//  PlaceInfoView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 14/02/22.
//

import SwiftUI

struct PlaceInfoView: View {
    init(place: VisitedPlace) {
        self.place = place
          /* UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "SF Pro Display-Black", size: 20)!]*/
    }
    
    var place: VisitedPlace
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                Text("Monastero di Santa Chiara")
                    .font(.title)
                    .fontWeight(.black)
                    .multilineTextAlignment(.leading)
                Text("Church")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(0..<10) {_ in
                        Image("monastero-santa-chiara-porticato-esterno")
                            .resizable()
                            .frame(width: 200.0, height: 200.0)
                            .cornerRadius(/*@START_MENU_TOKEN@*/22.0/*@END_MENU_TOKEN@*/)
                            .overlay(RoundedRectangle(cornerRadius: 21)
                                        .stroke(.black, lineWidth: 2))
                        }
                    }
                }
                Section() {
                TextEditor(text: .constant("write your thoughts!"))
                                .cornerRadius(12)
                                .lineSpacing(20)
                                .autocapitalization(.none)
                                //.frame(width: 300, height: 250)
                                //.clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding()
                    
                }
                //.cornerRadius(/*@START_MENU_TOKEN@*/12.0/*@END_MENU_TOKEN@*/)
                //.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(.black, lineWidth: 3))
            }
            .navigationTitle("Write Something")
        }
        .padding([.leading, .bottom, .trailing])
        
        
    }
}
struct PlaceInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceInfoView(place: VisitedPlace.makeRandom())
    }
    
}

