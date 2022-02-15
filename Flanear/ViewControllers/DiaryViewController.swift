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

class DiaryViewController: ObservableObject {
    
    let city: VisitedCity
    @Published var places: [VisitedPlace] = []
    var observableCancellable: AnyCancellable?
    
    init(city: VisitedCity) {
        self.city = city

        self.observableCancellable = ValueObservation
            .tracking { db in try city.places.fetchAll(db) }
            .publisher(in: AppDatabase.shared.databaseReader)
            .sink { error in
                print(error)
            } receiveValue: { updatedPlaces in
                self.places = updatedPlaces
            }
    }
    
    func deletePlace(place: VisitedPlace) {
        do {
            try AppDatabase.shared.deletePlaces(ids: [place.id!])
            self.places.removeAll { pl in
                return pl == place
            }
        } catch {
            print("Cannot delete place \(place.title)")
        }
        
        
    }
    
    func toggleStar(place: VisitedPlace) {
        var itemPlace = self.places.first { pl in
            return pl == place
        }!
        itemPlace.favourite.toggle()
        do {
            try AppDatabase.shared.savePlace(&itemPlace)
        }catch {
            preconditionFailure("Cannot save place")
        }
    }
    
    
}
