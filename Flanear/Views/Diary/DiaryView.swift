//
//  DiaryView.swift
//  Flanear
//
//  Created by Mattia Fochesato on 11/02/22.
//

import SwiftUI

struct DiaryView: View {
    let city: VisitedCity
    
    @ObservedObject var viewController: DiaryViewController
    
    init(city: VisitedCity) {
        self.city = city
        self.viewController = DiaryViewController(city: city)
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
                    Text("Such empty")
                        .bold()
                }else {
                    List {
                        Section(header: Text("Visited Places")) {
                            ForEach(viewController.places) { place in
                                NavigationLink {
                                    PlaceInfoView(place: place)
                                } label: {
                                    HStack {
                                        Image(systemName: place.favourite ? "star.fill" : "star")
                                            .font(.title2)
                                            .foregroundColor(place.favourite ? .yellow : .textBlack)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(place.title)
                                                .font(.title2)
                                            Text(place.description)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.leading, 6)
                                        .padding([.top, .bottom], 2)
                                    }
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            viewController.toggleStar(place: place)
                                        } label: {
                                            Label("Favourite", systemImage: place.favourite ? "star.slash" : "star.fill")
                                        }.tint(.yellow)
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            print("Deleting place")
                                            viewController.deletePlace(place: place)
                                        } label: {
                                            Label("Delete", systemImage: "trash.fill")
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }.navigationTitle(city.name)
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView(city: VisitedCity.makeRandom())
    }
}
