//
//  VisitedPlace.swift
//  Flanear
//
//  Created by Mattia Fochesato on 14/02/22.
//

import Foundation
import CoreLocation
import GRDB

/** VisitedPlace struct */
struct VisitedPlace: Identifiable, Hashable {
    var id: Int64?
    var cityId: Int64?
    var title: String
    var description: String
    var thoughts: String
    var favourite: Bool
    var coordinate: CLLocationCoordinate2D
}

extension VisitedPlace: FetchableRecord {
    /// Set the SQL rows
    init(row: Row) {
        id = row["id"]
        cityId = row["cityId"]
        title = row["title"]
        description = row["description"]
        thoughts = row["thoughts"]
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
        VisitedPlace(title: names.randomElement()!, description: "Test Place",thoughts: "Very good place!", favourite: bools.randomElement()!, coordinate: CLLocationCoordinate2D(latitude: randomScore(), longitude: randomScore()))
    }
    
    /// Returns a random score
    static func randomScore() -> CLLocationDegrees {
        10 * CLLocationDegrees.random(in: 0...10)
    }
}

extension VisitedPlace: TableRecord {
    /// Table name
    static let databaseTableName = "VisitedPlaces"
    
    /// Set relations
    static let city = belongsTo(VisitedCity.self)
    var city: QueryInterfaceRequest<VisitedCity> {
        request(for: VisitedPlace.city)
    }
    
    /// Set relations
    static let pictures = hasMany(Picture.self)
    var pictures: QueryInterfaceRequest<Picture> {
        request(for: VisitedPlace.pictures)
    }
}

extension VisitedPlace : MutablePersistableRecord {
    /// The values persisted in the database
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["cityId"] = cityId
        container["title"] = title
        container["description"] = description
        container["thoughts"] = thoughts
        container["favourite"] = favourite
        container["latitude"] = coordinate.latitude
        container["longitude"] = coordinate.longitude
    }
    
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension DerivableRequest where RowDecoder == VisitedPlace {
    /// Filters place by location
    func filter(latitude: CLLocationDegrees) -> Self {
        filter(Column("latitude") == latitude)
    }
    
    func filter(longitude: CLLocationDegrees) -> Self {
        filter(Column("longitude") == longitude)
    }
}
