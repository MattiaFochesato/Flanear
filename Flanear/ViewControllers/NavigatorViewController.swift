//
//  NavigatorViewController.swift
//  Flanear
//
//  Created by Mattia Fochesato on 11/02/22.
//

import Foundation
import MapKit
import CoreLocation
import Combine
import WatchConnectivity

class NavigatorViewController: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locations = [
        PlaceSearchItem(title: "Developer Academy", description: "Description todo", latitude: 40.836210, longitude: 14.306480),
        PlaceSearchItem(title: "San Giorgio a Cremano", description: "Description todo", latitude: 40.829170, longitude: 14.334190),
    ]
    
    @Published var suggestedLocations: [PlaceSearchItem]? = nil
    
    private var bearingDegrees: Double = .zero
    @Published var degrees: Double? = nil//.zero
    @Published var currentLocation: CLLocation?
    @Published var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.851799, longitude: 14.268120),
            span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        )
    @Published var destinationLocation: CLLocation? = nil//CLLocation(latitude: 40.829170, longitude: 14.334190)
    @Published var destinationDistance: CLLocationDistance = 0
    @Published var destinationName: String? = nil//"San Giorgio a Cremano"
    @Published var showSearch = false
    
    private var destinationNameCancellable: AnyCancellable? = nil
    private var degreesCancellable: AnyCancellable? = nil
    private var positionCancellable: AnyCancellable? = nil
    private var watchSearchCancellable: AnyCancellable? = nil
    private var significantLocationChangeCancellable: AnyCancellable? = nil
    
    var session: WCSession?
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            session = .default
            session?.delegate = self
            session?.activate()
        }
        
        self.degreesCancellable = LocationUtils.shared.$degrees.sink { _ in
            self.updateDegrees()
        }
        
        self.positionCancellable = LocationUtils.shared.$currentLocation.sink(receiveValue: { location in
            self.currentLocation = location
            
            self.updateDistance()
        })
        
        self.watchSearchCancellable = LocationUtils.shared.searchWatchPublisher.sink(receiveValue: { searchResults in
            if let validSession = self.session {
                let sendableResults = searchResults.map({
                    PlaceSearchItem($0)
                }).filter({ p in
                    return p.distance < 2000
                }).sorted(by: { p1, p2 in
                    return p1.distance < p2.distance
                })
                
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(sendableResults) {
                    let dataToSend = ["searchResults": encoded]

                    validSession.sendMessage(dataToSend, replyHandler: nil, errorHandler: { error in
                        print(error)
                    })
                }
                
                
            }
        })
        
        self.destinationNameCancellable = $destinationName.sink(receiveValue: { newDestination in
            if let validSession = self.session {
                let dataToSend = ["destinationName": newDestination]

                validSession.sendMessage(dataToSend as [String : Any], replyHandler: nil, errorHandler: { error in
                    print(error)
                })
            }
        })
        
        self.significantLocationChangeCancellable = LocationUtils.shared.significantLocationChange.sink(receiveValue: { _ in
            self.loadSuggestedLocations()
        })
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    func getBearingBetween(point1 : CLLocation, point2 : CLLocation) -> Double {

        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)

        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radians: radiansBearing)
    }
    
    func gotTo(place: PlaceSearchItem?) {
        destinationLocation = place?.location
        destinationName = place?.title
        showSearch = false
        
        self.updateDistance()
        self.updateDegrees()
        
        guard let place = place else { return }
        guard let currentCity = LocationUtils.shared.currentCity else { return }
        
        let isPlacePresent = try! AppDatabase.shared.isPlacePresent(coordinate: place.location.coordinate)
        
        if isPlacePresent {
            return
        }
        
        var visitedPlace = VisitedPlace(cityId: currentCity.id, title: place.title, description: place.subtitle, favourite: false, coordinate: place.location.coordinate)
        let _ = try! AppDatabase.shared.savePlace(&visitedPlace)
    }
    
    func updateDistance() {
        guard let location = self.currentLocation else { return }
        guard let destinationLocation = self.destinationLocation else { return }
        
        self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0007, longitudeDelta: 0.0007))
        
        //Update distance data
        self.bearingDegrees = self.getBearingBetween(point1: self.currentLocation!, point2: destinationLocation)
        self.destinationDistance = self.currentLocation!.distance(from: destinationLocation)
        
        if let validSession = self.session {
            let dataToSend = ["distance": self.destinationDistance, "degrees": self.bearingDegrees]

            validSession.sendMessage(dataToSend, replyHandler: nil, errorHandler: { error in
                print(error)
            })
        }
    }
    
    func updateDegrees() {
        guard let _ = self.destinationLocation else {
            self.degrees = nil
            return
        }
        
        self.degrees = -1 * LocationUtils.shared.degrees + self.bearingDegrees
        
        if let validSession = self.session {
            let dataToSend = ["degrees": self.bearingDegrees]

            validSession.sendMessage(dataToSend, replyHandler: nil, errorHandler: { error in
                print(error)
            })
        }
    }
    
    func loadSuggestedLocations() {
        guard let location = self.currentLocation else { return }
        
        var locs: [PlaceSearchItem] = []
        for loc in locations {
            var newLoc = loc
            newLoc.distance = location.distance(from: loc.location)
            locs.append(newLoc)
        }
        
        self.suggestedLocations = locs.filter { p in
            #if DEBUG
            return p.distance < 20000
            #else
            return p.distance < 2000
            #endif
        }.sorted { p1, p2 in
            return p1.distance < p2.distance
        }
        
        
    }
}

extension NavigatorViewController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            let loadSuggestions = message["loadSuggestions"] as? String
            let visitNewPlace = message["visitNewPlace"] as? Data
            
            if let _ = loadSuggestions {
                LocationUtils.shared.search(text: "restaurant", isWatch: true)
            }
            if let visitNewPlace = visitNewPlace {
                
                let decoder = JSONDecoder()
                
                if let placeToGo = try? decoder.decode(PlaceSearchItem.self, from: visitNewPlace) {
                    self.gotTo(place: placeToGo)
                }
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WC: sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WC: sessionDidDeactivate")
    }
    
    
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
