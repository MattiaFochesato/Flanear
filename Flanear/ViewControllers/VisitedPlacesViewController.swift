//
//  DiaryViewController.swift
//  Flanear
//
//  Created by Mattia Fochesato on 14/02/22.
//

import Foundation
import GRDB
import Combine
import SwiftUI

/** ViewController for PlacesView  */
class VisitedPlacesViewController: ObservableObject {
    
    /// VisitedCity selected
    let city: VisitedCity
    /// Places to show in the list
    @Published var places: [VisitedPlace] = []
    /// Cancellable to observe database changes
    var observableCancellable: AnyCancellable?
    
    /**
     - parameter city: VisitedCity to show.
     */
    init(city: VisitedCity) {
        /// Set local variables
        self.city = city
        
        /// Observe database changes
        self.observableCancellable = ValueObservation
            .tracking { db in try city.places.fetchAll(db) }
            .publisher(in: AppDatabase.shared.databaseReader)
            .sink { error in
                print(error)
            } receiveValue: { updatedPlaces in
                self.places = updatedPlaces
            }
    }
    
    /**
     Delete the place from the list and from the database
     
     - parameter place: VisitedPlace to delete.
     */
    func deletePlace(place: VisitedPlace) {
        do {
            /// Delete VisitedPlace from the database
            try AppDatabase.shared.deletePlaces(ids: [place.id!])
            /// Delete VisitedPlace from the list
            self.places.removeAll { pl in
                return pl == place
            }
        } catch {
            print("Cannot delete place \(place.title)")
        }
    }
    
    /**
     Toggle star of a selected place
     
     - parameter place: VisitedPlace to toggle.
     */
    func toggleStar(place: VisitedPlace) {
        /// Get the place from the list
        var itemPlace = self.places.first { pl in
            return pl == place
        }!
        /// Toggle favourite bool
        itemPlace.favourite.toggle()
        do {
            /// Save changes to the database
            try AppDatabase.shared.savePlace(&itemPlace)
        }catch {
            preconditionFailure("Cannot save place")
        }
    }
}
