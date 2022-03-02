//
//  Picture.swift
//  Flanear
//
//  Created by Mattia Fochesato on 14/02/22.
//

import Foundation
import CoreLocation
import GRDB

/** Picture struct */
struct Picture: Identifiable, Hashable {
    var id: Int64?
    var placeId: Int64?
    var data: Data
}

extension Picture: FetchableRecord {
    /// Set the SQL rows
    init(row: Row) {
        id = row["id"]
        placeId = row["placeId"]
        data = row["data"]
    }
}

extension Picture: TableRecord {
    /// Table name
    static let databaseTableName = "Pictures"
    
    /// Set relations
    static let place = belongsTo(VisitedPlace.self)
    var place: QueryInterfaceRequest<VisitedPlace> {
        request(for: Picture.place)
    }
}

extension Picture : MutablePersistableRecord {
    /// The values persisted in the database
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["placeId"] = placeId
        container["data"] = data
    }
    
    /// Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

