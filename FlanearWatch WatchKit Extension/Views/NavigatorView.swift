//
//  ContentView.swift
//  FlanearWatch WatchKit Extension
//
//  Created by Mattia Fochesato on 12/02/22.
//

import SwiftUI

struct NavigatorView: View {
    
    @EnvironmentObject var viewController: NavigatorViewController
    
    var body: some View {
        VStack {
            CompassCircleView(degrees: $viewController.degrees, startingDistance: $viewController.startingDistance, distance: $viewController.destinationDistance, placeName: .constant(""), arrived: .constant(false), openCamera: .constant(false))
                .padding()
            
            Spacer()
            
            Text(viewController.destinationName ?? NSLocalizedString("no-place-selected", comment: ""))
                .font(.title3)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .foregroundColor(.white)
        }
        .navigationTitle("Flanear")
        
    }
}

struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView()
    }
}
