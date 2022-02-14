//
//  DiaryViewController.swift
//  Flanear
//
//  Created by Mattia Fochesato on 14/02/22.
//

import Foundation
import GRDB
import SwiftUI

class DiaryViewController: ObservableObject {
    
    @Published var places: [VisitedPlace] = []
    
    init() {
        self.reloadPlaces()
    }
    
    private func reloadPlaces() {
        Task.init(priority: .userInitiated) {
            self.places = await fetchPlaces()
        }
    }
    
    private func fetchPlaces() async -> [VisitedPlace] {
        let places = try? await AppDatabase.shared.databaseReader.read { db in
            try VisitedPlace.fetchAll(db)
        }
        
        return places ?? []
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
            self.reloadPlaces()
        }catch {
            preconditionFailure("Cannot save place")
        }
    }
    
    
}
