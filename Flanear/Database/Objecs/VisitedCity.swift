//
//  VisitedCity.swift
//  Flanear
//
//  Created by Mattia Fochesato on 15/02/22.
//

//TODO: add automatic images
// https://codeburst.io/adding-city-images-to-your-react-app-14c937df2db2

import Foundation
import CoreLocation
import GRDB

/** VisitedPlace struct */
struct VisitedCity: Identifiable, Hashable {
    var id: Int64?
    var name: String
    var state: String
    var image: String
    
    /**
     Get the number of visited place in a city
     
     - returns: Percentage of visited places
     - warning: This function is still not implemented!
     */
    func getCompletion() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 3
        formatter.maximumFractionDigits = 0

        return formatter.string(from: NSNumber(value: 20 / 100.0)) ?? "-"
    }
}

extension VisitedCity: FetchableRecord {
    ///Set the SQL rows
    init(row: Row) {
        id = row["id"]
        name = row["name"]
        state = row["state"]
        image = row["image"]
    }
    
    /// Creates a new player with random name and random score
    static func makeRandom() -> VisitedCity {
        VisitedCity(name: "Naples", state: "Italy", image: "https://siviaggia.it/wp-content/uploads/sites/2/2020/08/innamorarsi-napoli.jpg")
    }
}

extension VisitedCity: TableRecord {
    /// Table Name
    static let databaseTableName = "VisitedCity"
    
    /// Set relations
    static let places = hasMany(VisitedPlace.self)
    var places: QueryInterfaceRequest<VisitedPlace> {
        request(for: VisitedCity.places)
    }
}

extension VisitedCity : MutablePersistableRecord {
    /// The values persisted in the database
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["name"] = name
        container["state"] = state
        container["image"] = image
    }
    
    /// Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

