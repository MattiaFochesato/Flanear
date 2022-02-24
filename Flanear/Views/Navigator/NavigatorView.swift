//
//  NavigatorView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 11/02/22.
//

import SwiftUI
import MapKit

struct NavigatorView: View {
    
    @ObservedObject var viewController = NavigatorViewController()
    @ObservedObject var searchViewController = PlaceSearchViewController()
    
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            NavigatorSearchableView()//searchText: $searchText)
                .navigationTitle("explore")
                .searchable(text: $searchViewController.searchText, placement: .navigationBarDrawer(displayMode: .always))
        }.environmentObject(viewController)
            .environmentObject(searchViewController)
    }
}

struct NavigatorSearchableView: View {
    @State var tracking: MapUserTrackingMode = .follow
    @Environment(\.isSearching) var isSearching
    
    @EnvironmentObject var viewController: NavigatorViewController
    
    var body: some View {
        ZStack {
            if !isSearching {
                Map(coordinateRegion: $viewController.region, interactionModes: .all, showsUserLocation: viewController.destinationLocation == nil, userTrackingMode: $tracking, annotationItems: viewController.locations) { location in
                    MapAnnotation(coordinate: location.location.coordinate) {
                        Button {
                            viewController.gotTo(place: location)
                        } label: {
                            Image(systemName: "star")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(3)
                                .background(.orange)
                                .clipShape(Circle())
                        }

                    }
                }//.ignoresSafeArea()
                .overlay(Rectangle()
                            .foregroundColor(.clear)
                            .background(viewController.destinationLocation == nil ? RadialGradient(gradient: Gradient(colors: [.clear]), center: .center, startRadius: 1000, endRadius: 1000) : RadialGradient(gradient: Gradient(colors: [.clear, .white]), center: .center, startRadius: 140, endRadius: 400))
                            .allowsHitTesting(false) )
                .disabled(viewController.destinationLocation == nil ? false : true)
                
                if viewController.destinationLocation != nil {
                    CompassCircleView(degrees: $viewController.degrees, near: .constant(0), distance: $viewController.destinationDistance, placeName: $viewController.destinationName)
                    
                }
                /*ZStack(alignment: .bottom) {
                    Color.clear
                    SuggestedPlacesView()
                        .frame(height: 200)
                        .cornerRadius(12)
                 }.zIndex(1000)*/
                
                if let destName = viewController.destinationName {
                    ZStack(alignment: .bottom) {
                        Color.clear
                        HStack {
                            Text(destName)
                        }.frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(.gray)
                     }.zIndex(1000)
                        .padding(.bottom, 1)//Fix for TabBar color iOS 15
                }
            }else{
                PlaceSearchView()
            }
        }
    }
    
}

struct SuggestedPlacesView: View {
    var body: some View {
        List {
            Text("Test")
        }.foregroundColor(.white)
    }
}

struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView()
    }
}
