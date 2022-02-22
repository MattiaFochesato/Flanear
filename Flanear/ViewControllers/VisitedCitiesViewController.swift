//
//  VisitedCitiesViewController.swift
//  Flanear
//
//  Created by Mattia Fochesato on 15/02/22.
//

import Foundation
import Combine
import GRDB

class VisitedCitiesViewController: ObservableObject {
    
    @Published var cities: [VisitedCity] = []
    var observableCancellable: AnyCancellable?
    
    init() {
        self.observableCancellable = ValueObservation
            .tracking { db in try VisitedCity.fetchAll(db) }
            .publisher(in: AppDatabase.shared.databaseReader)
            .sink { error in
                print(error)
            } receiveValue: { updatedCities in
                self.cities = updatedCities
            }
    }
}
