//
//  PlaceInfoView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 14/02/22.
//

import SwiftUI

struct PlaceInfoView: View {
    let place: VisitedPlace
    
    var body: some View {
        Text("Place info")
    }
}

struct PlaceInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceInfoView(place: VisitedPlace.makeRandom())
    }
}
