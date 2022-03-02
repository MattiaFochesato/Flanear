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

/** ViewController for PlaceSearchView  */
class PlaceSearchViewController: ObservableObject {
    
    /// Search results to show in the view
    @Published var searchResults: [PlaceSearchItem]? = nil
    /// Search text of the search label
    @Published var searchText: String = ""
    /// Cancellable used to subscribe to results
    private var cancellable: AnyCancellable?
    
    init() {
        /// Listen for results to search actions
        self.cancellable = LocationUtils.shared.searchPublisher.sink { items in
            /// Map the results to [PlaceSearchItem]
            self.searchResults = items.map({
                PlaceSearchItem($0)
            }).filter({ p in
                /// Filter them and remove places that are too far away
                return p.distance < 25000
            }).sorted(by: { p1, p2 in
                /// Sort by distance
                return p1.distance < p2.distance
            })
        }
    }
    
}
