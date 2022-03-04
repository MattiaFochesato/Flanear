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
            #if DEBUG
            return ("Undefined!","interests")
            #else
            return ("interests","interests")
            #endif
        }
        
        switch pointOfInterestCategory {
        case .museum:
            return ("museum", "museum")
        case .theater:
            return ("theater", "theater")
        case .amusementPark:
            return ("archeology", "archeology")
        case .park:
            return ("park", "park")
            default:
            #if DEBUG
                return ("und: \(pointOfInterestCategory.rawValue)","interests")
            #else
                return ("interests", "interests")
            #endif
        }
    }
    
}
