//
//  PickPlaceView.swift
//  FlanearWatch WatchKit Extension
//
//  Created by Mattia Fochesato on 12/02/22.
//

import SwiftUI

struct PickPlaceView: View {
    var body: some View {
        List {
            Button {
                print("todo")
            } label: {
                Text("TODO")
            }
            
        }.navigationTitle("Pick Place")
    }
}

struct PickPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PickPlaceView()
    }
}
