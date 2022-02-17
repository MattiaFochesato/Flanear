//
//  ContentView.swift
//  FlanearWatch WatchKit Extension
//
//  Created by Mattia Fochesato on 12/02/22.
//

import SwiftUI

struct NavigatorView: View {
    
    //@ObservedObject var viewController = NavigatorViewController()
    @EnvironmentObject var viewController: NavigatorViewController
    
    var body: some View {
        VStack {
            CompassCircleView(degrees: $viewController.degrees, near: .constant(1), distance: $viewController.destinationDistance, placeName: .constant(""))
                .padding()
            
            Spacer()
            
            Text(viewController.destinationName)
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
