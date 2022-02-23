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
                .navigationTitle("Explore")
                .searchable(text: $searchViewController.searchText)
        }.environmentObject(viewController)
            .environmentObject(searchViewController)
    }
}

struct NavigatorSearchableView: View {
    @State var tracking: MapUserTrackingMode = .follow
    @Environment(\.isSearching) var isSearching
    
    @EnvironmentObject var viewController: NavigatorViewController
    
    //@Binding var searchText: String
    
    var body: some View {
        ZStack {
            if !isSearching {
                Map(coordinateRegion: $viewController.region, interactionModes: .all, showsUserLocation: false, userTrackingMode: $tracking, annotationItems: viewController.locations) { location in
                    MapMarker(coordinate: location.coordinate)
                }//.ignoresSafeArea()
                .overlay(Rectangle()
                            .foregroundColor(.clear)
                            .background(RadialGradient(gradient: Gradient(colors: [.clear, .white]), center: .center, startRadius: 140, endRadius: 400))
                            .allowsHitTesting(false) )
                .disabled(true)
                
                CompassCircleView(degrees: $viewController.degrees, near: .constant(0), distance: $viewController.destinationDistance, placeName: $viewController.destinationName)
                
                /*ZStack(alignment: .top) {
                    Color.clear
                    SearchToolbarView(showSearch:  $viewController.showSearch)
                }.zIndex(1000)*/
            }else{
                PlaceSearchView()//searchText: $searchText)
                //Text("Test")
            }
        }
    }
    
}

struct SearchToolbarView: View {
    //@Binding var text: String
    //@State private var isEditing = false
    
    @Binding var showSearch: Bool
    
    var body: some View {
        VStack {
            Button {
                self.showSearch.toggle()
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
            
        }
        .padding([.leading, .trailing], 8)
        
    }
}

struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView()
    }
}
