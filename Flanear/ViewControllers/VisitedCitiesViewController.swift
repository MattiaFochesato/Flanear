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
class VisitedCitiesViewController: /*Pausable*/ObservableObject {
    
    /// Cities to display in the list (filtered if needed)
    @Published var cities: [VisitedCity] = []
    
    /**
     Load the list of cities from the database
     */
    func loadCities() {
        try? AppDatabase.shared.databaseReader.read { db in
            self.cities = try VisitedCity.fetchAll(db)
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
