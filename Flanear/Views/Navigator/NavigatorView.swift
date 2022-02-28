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
        VStack(spacing: 0) {
            ZStack {
                if !isSearching {
                    /*Map(coordinateRegion: $viewController.region, interactionModes: .all, showsUserLocation: viewController.destinationLocation == nil, userTrackingMode: $tracking, annotationItems: viewController.locations) { location in
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
                     }//.ignoresSafeArea()*/
                    MapView()
                        .overlay(Rectangle()
                                    .foregroundColor(.clear)
                                    .background(viewController.destinationLocation == nil ? RadialGradient(gradient: Gradient(colors: [.clear]), center: .center, startRadius: 1000, endRadius: 1000) : RadialGradient(gradient: Gradient(colors: [.clear, .textWhite]), center: .center, startRadius: 140, endRadius: 400))
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
                    
                    
                }else{
                    PlaceSearchView()
                }
            }
            if let destName = viewController.destinationName {
                if !isSearching {
                    //ZStack(alignment: .bottom) {
                    //Color.clear
                    Divider()
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.title.bold())
                        Text(destName)
                            .bold()
                        Spacer()
                        Button {
                            viewController.gotTo(place: nil)
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title.bold())
                                .foregroundColor(.textBlack)
                        }
                        
                    }
                    .padding([.leading, .trailing])
                    
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 6)
                    //.frame(height: 40)
                    .background(Color("DestinationSheetColor"))
                    //}//.zIndex(1000)
                    //.padding(.bottom, 1)//Fix for TabBar color iOS 15
                    
                    Divider()
                }
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
