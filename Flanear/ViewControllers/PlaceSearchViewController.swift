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

struct PlaceSearchItem: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var image: String
    var location: CLLocation?
    var distance: CLLocationDistance
    
    init(_ mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
        //self.subtitle = mapItem.placemark.title ?? ""
        
        let info = mapItem.getPOIInfo()
        self.subtitle = info.0//mapItem.pointOfInterestCategory?.rawValue ?? "-"
        self.image = info.1
        
        self.location = mapItem.placemark.location
        self.distance = 0
        if let location = location {
            if let curLoc = LocationUtils.shared.currentLocation {
                self.distance = location.distance(from: curLoc)
            }
        }
    }
}

extension MKMapItem {
    
    func getPOIInfo() -> (String, String) {
        
        guard let pointOfInterestCategory = pointOfInterestCategory else {
            return ("undefined","questionmark.circle.fill")
        }
        
        switch pointOfInterestCategory {
            case .amusementPark:
                return ("amusementPark","t.circle")
            case .aquarium:
                return ("acquarium","t.circle")
            case .beach:
                return ("beach","t.circle")
            case .cafe:
                return ("cafe","t.circle")
            case .restaurant:
                return ("restourant","t.circle")
            case .publicTransport:
                return ("publicTransport", "tram.fill")
            default:
                return ("und: \(pointOfInterestCategory.rawValue)","t.circle")
        }
    }
    
}
