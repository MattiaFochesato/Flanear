//
//  PlaceInfoViewController.swift
//  Flanear
//
//  Created by Mattia Fochesato on 28/02/22.
//


import Foundation
import GRDB
import Combine
import SwiftUI

/** Struct to keep the image to show  */
struct PlaceInfoPicture: Identifiable {
    var id: Int64?
    var image: UIImage
    var object: Picture
}

/** ViewController for PlaceInfoView  */
class PlaceInfoViewController: ObservableObject {
    
    /// VisitedPlace selected
    let place: VisitedPlace
    /// Pictures to show in the view
    @Published var pictures: [PlaceInfoPicture] = []
    /// Cancellable to subscribe to database changes for pictures table
    var observableCancellable: AnyCancellable?
    
    /**
     - parameter place: VisitedPlace to show.
     */
    init(place: VisitedPlace) {
        /// Set local variables
        self.place = place

        /// Observe database changes
        self.observableCancellable = ValueObservation
            .tracking { db in try place.pictures.fetchAll(db) }
            .publisher(in: AppDatabase.shared.databaseReader)
            .sink { error in
                print(error)
            } receiveValue: { updatedPictures in
                /// Extract UIImage from Data and save to the local
                var images: [PlaceInfoPicture] = []
                for pic in updatedPictures {
                    images.append(PlaceInfoPicture(id: pic.id, image: UIImage(data: pic.data)!, object: pic))
                }
                self.pictures = images
            }
    }
    
    /**
     Delete the picture from the list and from the database
     
     - parameter picture: PlaceInfoPicture to delete.
     */
    func delete(picture: PlaceInfoPicture) {
        do {
            /// Delete PlaceInfoPicture from the database
            try AppDatabase.shared.delete(picture: picture.object)
            /// Delete PlaceInfoPicture from the list
            self.pictures.removeAll { p in
                return p.id == picture.id
            }
        } catch {
            print("Cannot delete picture id: \(picture.id ?? -1)")
        }
        
        
    }
    
}
