//
//  PlaceSearchItem.swift
//  Flanear
//
//  Created by Mattia Fochesato on 17/02/22.
//

import Foundation
import CoreLocation
import MapKit

struct PlaceSearchItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var subtitle: String
    var image: String
    //var location: CLLocation?
    var distance: CLLocationDistance
    
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0

    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    init(_ mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
       
        
        //self.location = mapItem.placemark.location
        if let location = mapItem.placemark.location {
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }
        self.distance = 0
        #if os(watchOS)
        self.subtitle = mapItem.placemark.subtitle ?? "UNKNOWN"
        self.image = ""
        self.distance = 0//TODO
        #else
        let info = mapItem.getPOIInfo()
        self.subtitle = info.0//mapItem.pointOfInterestCategory?.rawValue ?? "-"
        self.image = info.1
        //if let location = location {
            if let curLoc = LocationUtils.shared.currentLocation {
                self.distance = location.distance(from: curLoc)
            }
        //}
        #endif
    }
    
    init() {
        self.title = "Item 1"
        self.subtitle = "Subtitle"
        self.image = ""
        //self.location = CLLocation(latitude: 10, longitude: 10)
        self.distance = 300
    }
    
}
