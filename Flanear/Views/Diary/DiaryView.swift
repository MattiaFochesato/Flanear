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
        NavigationView {
            VStack {
                List {
                    if viewController.places.isEmpty {
                        Text("Such empty")
                    }else {
                        ForEach(viewController.places) { place in
                            NavigationLink {
                                PlaceInfoView(place: place)
                            } label: {
                                HStack {
                                    Image(systemName: place.favourite ? "star.fill" : "star")
                                        .font(.title2)
                                        .foregroundColor(.yellow)
                                    VStack(alignment: .leading) {
                                        Text(place.title)
                                            .font(.title2)
                                        Text(place.description)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }.padding(.leading, 8)
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
        }.navigationTitle("Diary")
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView(city: VisitedCity.makeRandom())
    }
}
