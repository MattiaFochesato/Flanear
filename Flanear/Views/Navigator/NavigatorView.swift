//
//  NavigatorView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 11/02/22.
//

import SwiftUI
import MapKit

struct NavigatorView: View {
    @State var tracking: MapUserTrackingMode = .follow
    @ObservedObject var viewController = NavigatorViewController()
    
    var body: some View {
        NavigationView {
        ZStack {
            
            Map(coordinateRegion: $viewController.region, interactionModes: .all, showsUserLocation: false, userTrackingMode: $tracking, annotationItems: viewController.locations) { location in
                MapMarker(coordinate: location.coordinate)
            }//.ignoresSafeArea()
            .overlay(Rectangle()
                        .foregroundColor(.clear)
                        .background(RadialGradient(gradient: Gradient(colors: [.clear, .white]), center: .center, startRadius: 140, endRadius: 400))
                        .allowsHitTesting(false) )
            .disabled(true)
            
            CompassCircleView(degrees: $viewController.degrees, near: .constant(0), distance: $viewController.destinationDistance, placeName: $viewController.destinationName)
            
            ZStack(alignment: .top) {
                Color.clear
                SearchView()
            }.zIndex(1000)
            
            
        }
    }
    }
}

struct SearchView: View {
    var body: some View {
        VStack {
            Button {
                print("click")
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                    Text("Search")
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }.frame(height: 40)
                    .padding(.leading, 16)
                    .background(RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.gray))
            }

            HStack {
                Spacer()
                NavigationLink(destination: ARMapView()) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(.gray))
                }//.navigationBarTitle("")
                 //   .navigationBarHidden(true)
            }
                
        }
            .padding([.leading, .trailing], 8)
        
    }
}

struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView()
    }
}
