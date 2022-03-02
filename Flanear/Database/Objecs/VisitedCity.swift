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

//VisitedPlace struct
struct VisitedCity: Identifiable, Hashable {
    var id: Int64?
    var name: String
    var state: String
    var image: String
    
    func getCompletion() -> Int {
        return 20
    }
}

//Set the SQL rows
extension VisitedCity: FetchableRecord {
    init(row: Row) {
        id = row["id"]
        name = row["name"]
        state = row["state"]
        image = row["image"]
    }
    
    /// Creates a new player with random name and random score
    static func makeRandom() -> VisitedCity {
        VisitedCity(name: "Napoli", state: "Italia", image: "https://siviaggia.it/wp-content/uploads/sites/2/2020/08/innamorarsi-napoli.jpg")
    }
}

//Set the table name
extension VisitedCity: TableRecord {
    static let databaseTableName = "VisitedCity"
    
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
    
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

