//
//  ContentView.swift
//  FlanearWatch WatchKit Extension
//
//  Created by Mattia Fochesato on 12/02/22.
//

import SwiftUI

struct NavigatorView: View {
    var body: some View {
        
            //ScrollView {
                VStack {
                    CompassCircleView(degrees: .constant(30), near: .constant(1), distance: .constant(300), placeName: .constant("San Giovanni"))
                        .padding()
                    Spacer()
                    Text("testo")
                //}
            }.background(.gray)
            
        .navigationTitle("Flanear")
    }
}

struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView()
    }
}
