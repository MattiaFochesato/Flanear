//
//  DiaryView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 11/02/22.
//

import SwiftUI

struct PlacesView: View {
    let city: VisitedCity
    
    @ObservedObject var viewController: VisitedPlacesViewController
    @State var searchText = ""
    @State var showPlace: VisitedPlace? = nil
    
    init(city: VisitedCity) {
        self.city = city
        self.viewController = VisitedPlacesViewController(city: city)
    }
    
    var body: some View {
            VStack {
                if viewController.places.isEmpty {
                    Image(systemName: "map.fill")
                        .font(.largeTitle)
                        .foregroundColor(.textWhite)
                        .padding(10)
                        .background(Color.textBlack)
                        .clipShape(Circle())
                    Text("no-place-visited-in \(city.name)")
                        .bold()
                }else {
                    List {
                        Section(header: Text("visited-places")) {
                            ForEach(viewController.places) { place in
                                NavigationLink {
                                    PlaceInfoView(place: place)
                                    //print("open")
                                    //self.showPlace = place
                                } label: {
                                    HStack {
                                        Image(systemName: place.favourite ? "star.fill" : "star")
                                            .font(.title2)
                                            .foregroundColor(place.favourite ? .yellow : .textBlack)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(place.title)
                                                .font(.title3)
                                            Text(place.description)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.leading, 6)
                                        .padding([.top, .bottom], 2)
                                    }
                                    
                                }.swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        viewController.toggleStar(place: place)
                                    } label: {
                                        Label("", systemImage: place.favourite ? "star.slash" : "star.fill")
                                    }.tint(.yellow)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        print("Deleting place")
                                        viewController.deletePlace(place: place)
                                    } label: {
                                        Label("", systemImage: "trash.fill")
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }.navigationTitle(city.name)
            .searchable(text: $searchText)
            /*.sheet(isPresented: Binding(get: {
                self.showPlace != nil
            }, set: {
                if !$0 {
                    self.showPlace = nil
                }
            })) {
                NavigationView {
                    if let showPlace = showPlace {
                        PlaceInfoView(place: showPlace)
                    }else{
                        EmptyView()
                    }
                }
            }*/
    }
}

struct PlacesView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesView(city: VisitedCity.makeRandom())
    }
}
