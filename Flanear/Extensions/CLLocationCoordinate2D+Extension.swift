//
//  CLLocationCoordinate2D+Extension.swift
//  Flanear
//
//  Created by Mattia Fochesato on 14/02/22.
//

import Foundation
import CoreLocation

/** Make CLLocationCoordinate2D Hashable */
extension CLLocationCoordinate2D: Hashable {
    
    /// Implement == function
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    /// Implement hash function
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
