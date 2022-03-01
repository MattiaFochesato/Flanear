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

class PlaceInfoViewController: ObservableObject {
    
    let place: VisitedPlace
    @Published var pictures: [PlaceInfoPicture] = []
    var observableCancellable: AnyCancellable?
    
    init(place: VisitedPlace) {
        self.place = place

        self.observableCancellable = ValueObservation
            .tracking { db in try place.pictures.fetchAll(db) }
            .publisher(in: AppDatabase.shared.databaseReader)
            .sink { error in
                print(error)
            } receiveValue: { updatedPictures in
                var images: [PlaceInfoPicture] = []
                for pic in updatedPictures {
                    //images.append(Image(uiImage: UIImage(data: pic.data)!))
                    images.append(PlaceInfoPicture(id: pic.id, image: UIImage(data: pic.data)!, object: pic))
                }
                self.pictures = images
            }
    }
    
    func delete(picture: PlaceInfoPicture) {
        do {
            try AppDatabase.shared.delete(picture: picture.object)
            self.pictures.removeAll { p in
                return p.id == picture.id
            }
        } catch {
            print("Cannot delete picture id: \(picture.id ?? -1)")
        }
        
        
    }
    
}

struct PlaceInfoPicture: Identifiable {
    var id: Int64?
    var image: UIImage
    var object: Picture
}
