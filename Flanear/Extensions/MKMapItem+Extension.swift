//
//  MKMapItem+Extension.swift
//  Flanear
//
//  Created by Mattia Fochesato on 02/03/22.
//

import Foundation
import MapKit

extension MKMapItem {
    
    /**
     Get the POI localized info
     
     - returns: (String: Localized POI description, String: systemImage icon)
     */
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
