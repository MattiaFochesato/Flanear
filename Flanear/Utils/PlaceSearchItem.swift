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
    var distance: CLLocationDistance
    
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    init(title: String, description: String, latitude: Double, longitude: Double) {
        self.title = title
        self.subtitle = description
        
        self.image = ""
        self.distance = 0
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
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
        self.subtitle = info.0
        self.image = info.1
        if let curLoc = LocationUtils.shared.currentLocation {
            self.distance = location.distance(from: curLoc)
        }
        
#endif
    }
    
    init() {
        self.title = "Item 1"
        self.subtitle = "Subtitle"
        self.image = ""
        self.distance = 300
    }
    
}
