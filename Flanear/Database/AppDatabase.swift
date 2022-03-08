//
//  AppDatabase.swift
//  Flanear
//
//  Created by Mattia Fochesato on 14/02/22.
//

import GRDB
import CoreLocation
import SwiftUI

/// AppDatabase lets the application access the database.
///
/// It applies the pratices recommended at
/// <https://github.com/groue/GRDB.swift/blob/master/Documentation/GoodPracticesForDesigningRecordTypes.md>
final class AppDatabase {
    /// Creates an `AppDatabase`, and make sure the database schema is ready.
    init(_ dbWriter: DatabaseWriter) throws {
        self.dbWriter = dbWriter
        try migrator.migrate(dbWriter)
    }
    
    /// Provides access to the database.
    ///
    /// Application can use a `DatabasePool`, and tests can use a fast
    /// in-memory `DatabaseQueue`.
    ///
    /// See <https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections>
    private let dbWriter: DatabaseWriter
    
    /// The DatabaseMigrator that defines the database schema.
    ///
    /// See <https://github.com/groue/GRDB.swift/blob/master/Documentation/Migrations.md>
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        // Speed up development by nuking the database when migrations change
        // See https://github.com/groue/GRDB.swift/blob/master/Documentation/Migrations.md#the-erasedatabaseonschemachange-option
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        migrator.registerMigration("firstMigration") { db in
            // Create a table
            // See https://github.com/groue/GRDB.swift#create-tables
            
            /* VISITED CITY */
            try db.create(table: VisitedCity.databaseTableName, body: { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
                t.column("state", .text).notNull()
                t.column("image", .text).notNull()
            })
            
            /* VISITED PLACE */
            try db.create(table: VisitedPlace.databaseTableName) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("cityId", .integer)
                    .notNull()
                    .indexed()
                    .references(VisitedCity.databaseTableName, onDelete: .cascade)
                t.column("title", .text).notNull()
                t.column("description", .text)
                t.column("thoughts", .text)
                t.column("favourite", .boolean).notNull()
                t.column("latitude", .double).notNull()
                t.column("longitude", .double).notNull()
            }

            /* PICTURES */
            try db.create(table: Picture.databaseTableName) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("placeId", .integer)
                    .notNull()
                    .indexed()
                    .references(VisitedPlace.databaseTableName, onDelete: .cascade)
                t.column("data", .blob).notNull()
            }
        }
        return migrator
    }
}

// MARK: - Database Access: Writes
extension AppDatabase {
    
    /// Delete the specified place
    func deleteCity(city: VisitedCity) throws {
        try dbWriter.write { db in
            /// This also deletes all places since there is a relation
            _ = try VisitedCity.deleteAll(db, ids: [city.id!])
        }
    }
    
    /// Create random players if the database is empty.
    func createRandomPlacesIfEmpty() throws {
        try dbWriter.write { db in
            if try VisitedPlace.all().isEmpty(db) {
                //try createRandomPlaces(db)
            }
        }
    }
    
    /// Create random places for testing
    private func createRandomPlaces(_ db: Database) throws {
        for _ in 0..<8 {
            _ = try VisitedPlace.makeRandom().inserted(db) // insert but ignore inserted id
        }
    }
    
    /// Delete the specified place
    func deletePlaces(ids: [Int64]) throws {
        try dbWriter.write { db in
            _ = try VisitedPlace.deleteAll(db, ids: ids)
        }
    }
    
    /// Saves (inserts or updates) a player. When the method returns, the
    /// player is present in the database, and its id is not nil.
    func savePlace(_ place: inout VisitedPlace) throws {
        try dbWriter.write { db in
            try place.save(db)
        }
    }
    
    
    /* VISITED CITY */
    /// Saves (inserts or updates) a player. When the method returns, the
    /// player is present in the database, and its id is not nil.
    func saveCity(_ city: inout VisitedCity) throws {
        try dbWriter.write { db in
            try city.save(db)
        }
    }
    /**
     Checks if a placemark is present in the database given the `CLLocationCoordinate2D`
     
     - parameter coordinate: The coordinate of the placemark to check.
     - returns: The `VisitedPlace` if present
     
     Since we don't have an identifier for placemarks, we are using the coordinate as identifier
     */
    func isPlacePresent(coordinate: CLLocationCoordinate2D) throws -> VisitedPlace? {
        var result: VisitedPlace? = nil
        try dbWriter.read { db in
            let places = try VisitedPlace.all()
                .filter(latitude: coordinate.latitude)
                .filter(longitude: coordinate.longitude)
                .fetchAll(db)
            
            result = places.first
        }
        return result
    }
    
    /**
     Adds an image to a `VisitedPlace` and saves it in the database
     
     - parameters:
        - image: `UIImage` to add
        - place: `VisitedPlace` of the image
     */
    func add(image: UIImage, to place: VisitedPlace) throws {
        guard let imageData = image.pngData() else {
            return
        }
        
        var picture = Picture(placeId: place.id, data: imageData)
        try dbWriter.write { db in
            try picture.save(db)
        }
    }
    
    /// Delete the specified picture
    func delete(picture: Picture) throws {
        try dbWriter.write { db in
            _ = try Picture.deleteAll(db, ids: [picture.id!])
        }
    }
}

// MARK: - Database Access: Reads
extension AppDatabase {
    /// Provides a read-only access to the database
    var databaseReader: DatabaseReader {
        dbWriter
    }
}
