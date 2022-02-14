//
//  VisitedPlace.swift
//  Flanear
//
//  Created by Mattia Fochesato on 14/02/22.
//

import Foundation
import CoreLocation
import GRDB

//VisitedPlace struct
struct VisitedPlace: Identifiable, Hashable {
    var id: Int64?
    var title: String
    var description: String
    var favourite: Bool
    var coordinate: CLLocationCoordinate2D
}

//Set the SQL rows
extension VisitedPlace: FetchableRecord {
    init(row: Row) {
        id = row["id"]
        title = row["title"]
        description = row["description"]
        favourite = row["favourite"]
        coordinate = CLLocationCoordinate2D(
            latitude: row["latitude"],
            longitude: row["longitude"])
    }
    
    private static let names = [
           "Arthur", "Anita", "Barbara", "Bernard", "Craig", "Chiara", "David",
           "Dean", "Éric", "Elena", "Fatima", "Frederik", "Gilbert", "Georgette",
           "Henriette", "Hassan", "Ignacio", "Irene", "Julie", "Jack", "Karl",
           "Kristel", "Louis", "Liz", "Masashi", "Mary", "Noam", "Nicole",
           "Ophelie", "Oleg", "Pascal", "Patricia", "Quentin", "Quinn", "Raoul",
           "Rachel", "Stephan", "Susie", "Tristan", "Tatiana", "Ursule", "Urbain",
           "Victor", "Violette", "Wilfried", "Wilhelmina", "Yvon", "Yann",
           "Zazie", "Zoé"]
    
    private static let bools = [true, false]
    
    /// Creates a new player with random name and random score
    static func makeRandom() -> VisitedPlace {
        VisitedPlace(id: nil, title: names.randomElement()!, description: "Test Place", favourite: bools.randomElement()!, coordinate: CLLocationCoordinate2D(latitude: randomScore(), longitude: randomScore()))
    }
    
    /// Returns a random score
    static func randomScore() -> CLLocationDegrees {
        10 * CLLocationDegrees.random(in: 0...100)
    }
}

//Set the table name
extension VisitedPlace: TableRecord {
    static let databaseTableName = "VisitedPlaces"
}

extension VisitedPlace : MutablePersistableRecord {
    /// The values persisted in the database
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["title"] = title
        container["description"] = description
        container["favourite"] = favourite
        container["latitude"] = coordinate.latitude
        container["longitude"] = coordinate.longitude
    }
    
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
