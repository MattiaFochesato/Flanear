//
//  VisitedCitiesViewController.swift
//  Flanear
//
//  Created by Mattia Fochesato on 15/02/22.
//

import Foundation
import Combine
import GRDB

/** ViewController for CitiesView */
class VisitedCitiesViewController: ObservableObject {
    
    /// Cities to display in the list (filtered if needed)
    @Published var cities: [VisitedCity] = []
    /// Cancellable used to subscribe to database changes
    var observableCancellable: AnyCancellable?
    
    init() {
        /// Observe database changes
        self.observableCancellable = ValueObservation
            .tracking { db in try VisitedCity.fetchAll(db) }
            .publisher(in: AppDatabase.shared.databaseReader)
            .sink { error in
                print(error)
            } receiveValue: { updatedCities in
                self.cities = updatedCities
            }
    }
    
    /**
     Delete the city from the list and from the database
     
     - parameter city: VisitedCity to delete.
     */
    func deleteCity(city: VisitedCity) {
        do {
            /// Delete VisitedCity from the database
            try AppDatabase.shared.deleteCity(city: city)
            /// Delete VisitedCity from the list
            self.cities.removeAll { c in
                return c == city
            }
        } catch {
            print("Cannot delete city \(city.name)")
        }
        
        
    }
}
