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

/** ViewController for NavigatorView  */
class NavigatorViewController: NSObject, ObservableObject, CLLocationManagerDelegate {
    ///Suggested location that the user can choose (filtered and ordered by distance)
    @Published var suggestedLocations: [PlaceSearchItem]? = nil
    
    ///Bearing Degrees for two points
    private var bearingDegrees: Double = .zero
    ///Degrees based on current compass degrees that points to the destination
    @Published var degrees: Double? = nil
    ///Current Location
    @Published var currentLocation: CLLocation?
    ///Region to show in the map when the app is opened
    @Published var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.851799, longitude: 14.268120),
            span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        )
    ///Location of the destination place
    @Published var destinationLocation: CLLocation? = nil
    ///Distance from the destination place (always updated)
    @Published var destinationDistance: CLLocationDistance = 0
    ///The initial distance from the destination (used to fill the inner circle when the user is close to the destination)
    @Published var startingDistance: CLLocationDistance = 0
    ///The name of the destination place
    @Published var destinationName: String? = nil
    ///Bool used to keep track if the search is showing in the view
    @Published var showSearch = false
    ///Bool used to update the compass view when the user arrives
    @Published var isArrived = false
    
    /** Cancellables used to keep track of some variables changes */
    private var destinationNameCancellable: AnyCancellable? = nil
    private var degreesCancellable: AnyCancellable? = nil
    private var positionCancellable: AnyCancellable? = nil
    private var watchSearchCancellable: AnyCancellable? = nil
    private var significantLocationChangeCancellable: AnyCancellable? = nil
    
    ///WCSession used for comunicating with the Apple Watch App
    var session: WCSession?
    
    override init() {
        super.init()
        
        ///Activate the Apple Watch communication if supported
        if WCSession.isSupported() {
            session = .default
            session?.delegate = self
            session?.activate()
        }
        
        ///Subscribe to compass degrees changes
        self.degreesCancellable = LocationUtils.shared.$degrees.sink { _ in
            self.updateDegrees()
        }
        
        ///Subscribe to location changes
        self.positionCancellable = LocationUtils.shared.$currentLocation.sink(receiveValue: { location in
            self.currentLocation = location
            
            self.updateDistance()
        })
        
        ///Subscribe to Apple Watch Search event
        self.watchSearchCancellable = LocationUtils.shared.searchWatchPublisher.sink(receiveValue: { searchResults in
            if let validSession = self.session {
                ///If there are any results, map the result to a PlaceSearch item, filter and order them
                let sendableResults = searchResults.map({
                    PlaceSearchItem($0)
                }).filter({ p in
                    return p.distance < 2000
                }).sorted(by: { p1, p2 in
                    return p1.distance < p2.distance
                })
                
                ///Encode the results in JSON
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(sendableResults) {
                    let dataToSend = ["searchResults": encoded]

                    ///Send the data to the Apple Watch app
                    validSession.sendMessage(dataToSend, replyHandler: nil, errorHandler: { error in
                        print(error)
                    })
                }
                
                
            }
        })
        
        ///Subscribe to Destination Name Change
        self.destinationNameCancellable = $destinationName.sink(receiveValue: { newDestination in
            if let validSession = self.session {
                let dataToSend = ["destinationName": newDestination]

                validSession.sendMessage(dataToSend as [String : Any], replyHandler: nil, errorHandler: { error in
                    print(error)
                })
            }
        })
        
        ///Subscribe to significant location change
        self.significantLocationChangeCancellable = LocationUtils.shared.significantLocationChange.sink(receiveValue: { _ in
            self.loadSuggestedLocations()
        })
    }
    
    /**
     Convert degrees to radians
     
     - parameter degrees: Degrees to convert.
     - returns: Radians equivalent
     */
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    
    /**
     Convert radians to degrees
     
     - parameter radians: Radians to convert.
     - returns: Degrees equivalent
     */
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    /**
     Get the bearing between two CLLocation poins
     
     - parameters:
        - point1: First point.
        - point2: Second point.
     - returns: Bearing in degrees
     */
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
    /**
     Function used to change the destination
     
     - parameter place: Should be nil to cancel the navigation or an instance of PlaceSearchItem to change the destinatioj.
     
     */
    func gotTo(place: PlaceSearchItem?) {
        /// Update all  the local variables
        LocationUtils.shared.currentPlace = nil
        destinationLocation = place?.location
        destinationName = place?.title
        showSearch = false
        isArrived = false
        
        /// Update distance and degrees in the navigator view
        self.updateDistance()
        self.updateDegrees()
        self.startingDistance = destinationDistance
        
        guard let place = place else { return }
        guard let currentCity = LocationUtils.shared.currentCity else { return }
        
        /// Check if place is already present in the database
        let isPlacePresent = try! AppDatabase.shared.isPlacePresent(coordinate: place.location.coordinate)
        
        /// If the place is already present, save it in the sheared variable
        if let place = isPlacePresent {
            LocationUtils.shared.currentPlace = place
            return
        }
        
        /// If the place is not present, create and save it
        var visitedPlace = VisitedPlace(cityId: currentCity.id, title: place.title, description: place.subtitle, thoughts: " ", favourite: false, coordinate: place.location.coordinate)
        let _ = try? AppDatabase.shared.savePlace(&visitedPlace)
        LocationUtils.shared.currentPlace = visitedPlace
    }
    
    /**
    Call this function to update the distance from the current position and the destination place.
     */
    func updateDistance() {
        /// Check if the current location and the destination locations are set
        guard let location = self.currentLocation else { return }
        guard let destinationLocation = self.destinationLocation else { return }
        
        /// Update the map region to show
        self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0007, longitudeDelta: 0.0007))
        
        /// Update distance data and the bearing degrees
        self.bearingDegrees = self.getBearingBetween(point1: self.currentLocation!, point2: destinationLocation)
        self.destinationDistance = self.currentLocation!.distance(from: destinationLocation)
        
        /// Check if the destination distance is greater than the starting distance
        if self.destinationDistance > self.startingDistance {
            /// If yes, update the starting distance. The user is going in the opposite direction!
            self.startingDistance = self.destinationDistance
        }
        
        /// Check if the user is near the destination
        if self.destinationDistance <= 15 {
            /// If yes, set isArrived = true to show the arrived view
            self.isArrived = true
        }
        
        /// Send distance updates to the Apple Watch app if present
        if let validSession = self.session {
            let dataToSend = ["distance": self.destinationDistance, "degrees": self.bearingDegrees]

            validSession.sendMessage(dataToSend, replyHandler: nil, errorHandler: { error in
                print(error)
            })
        }
    }
    
    /**
    Call this function to update the compass degrees.
     */
    func updateDegrees() {
        /// Check if the destination location is set
        guard let _ = self.destinationLocation else {
            self.degrees = nil
            return
        }
        
        /// Update the degrees of the destination
        self.degrees = -1 * LocationUtils.shared.degrees + self.bearingDegrees
        
        /// Send distance updates to the Apple Watch app if present
        if let validSession = self.session {
            let dataToSend = ["degrees": self.bearingDegrees]

            validSession.sendMessage(dataToSend, replyHandler: nil, errorHandler: { error in
                print(error)
            })
        }
    }
    
    /**
    Call this function to update suggested locations based on the current user positions
     */
    func loadSuggestedLocations() {
        /// Check if the current location is set
        guard let location = self.currentLocation else { return }
        
        /// Get the distance from every landmark
        var locs: [PlaceSearchItem] = []
        for loc in MapView.LANDMARKS {
            var newLoc = loc.getPlaceSearchItem()
            newLoc.image = loc.type.rawValue
            newLoc.distance = location.distance(from: newLoc.location)
            locs.append(newLoc)
        }
        
        /// Filter and sort the results
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
    /**
     Handle messages from the Apple Watch App
     */
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            let loadSuggestions = message["loadSuggestions"] as? String
            let visitNewPlace = message["visitNewPlace"] as? Data
            
            /// If the Apple Watch asks for suggestions, load and send the result
            if let _ = loadSuggestions {
                LocationUtils.shared.search(text: "restaurant", isWatch: true)
            }
            
            /// If the Apple Watch asks to change the destination place, decode it and call .goTo(place: )
            if let visitNewPlace = visitNewPlace {
                let decoder = JSONDecoder()
                
                if let placeToGo = try? decoder.decode(PlaceSearchItem.self, from: visitNewPlace) {
                    self.gotTo(place: placeToGo)
                }
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WC: activationDidCompleteWith")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WC: sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WC: sessionDidDeactivate")
    }
    
    
}

