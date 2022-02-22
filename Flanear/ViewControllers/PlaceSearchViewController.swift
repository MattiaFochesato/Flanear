//
//  PlaceSearchViewController.swift
//  Flanear
//
//  Created by Mattia Fochesato on 15/02/22.
//

import Foundation
import SwiftUI
import Combine
import MapKit

class PlaceSearchViewController: ObservableObject {
    
    //private var disposeBag = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?
    @Published var searchResults: [PlaceSearchItem]? = nil
    @Published var searchText = ""/*{
        didSet {
            //LocationUtils.shared.search(for: .pointOfInterest, text: searchText)
        }
    }*/
    
    init() {
        self.cancellable = LocationUtils.shared.searchPublisher.sink { items in
            self.searchResults = items.map({
                PlaceSearchItem($0)
            }).filter({ p in
                return p.distance < 2000
            }).sorted(by: { p1, p2 in
                return p1.distance < p2.distance
            })
        }
        
        /*$searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { searchText in
                LocationUtils.shared.search(for: .pointOfInterest, text: searchText)
            }
            .store(in: &disposeBag)*/
    }
    
}
