//
//  LocationUtils.swift
//  Flanear
//
//  Created by Mattia Fochesato on 15/02/22.
//

import Foundation
import CoreLocation
import Combine
import GRDB
import MapKit

/** An utility class used to manage the user location and compass */
class LocationUtils: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    /// Singleton
    static let shared = LocationUtils()
    /// Instance of CLLocationManager
    private let locationManager: CLLocationManager
    
    /// Published variables to share the data
    @Published var degrees: Double = .zero
    @Published var currentLocation: CLLocation?
    @Published var currentCity: VisitedCity?
    @Published var currentPlace: VisitedPlace?
    
    /// PassthroughSubject used to send data to subscribers
    let searchPublisher = PassthroughSubject<[MKMapItem], Never>()
    let searchWatchPublisher = PassthroughSubject<[MKMapItem], Never>()
    let significantLocationChange = PassthroughSubject<Bool, Never>()
    
    /// Starting position used to check for relevant position change
    var startingPosition: CLLocation? = nil
    
    /** init() function */
    override init() {
        /// Instantiate CLLocationManager and set background mode
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        
        /// Call super.init()
        super.init()
        
        /// Set CLLocationManagerDelegate and start the CLLocationManager
        self.locationManager.delegate = self
        self.startLocationManager()
    }
    
    /** Setup CLLocationManager */
    private func startLocationManager() {
        /// Request location authorization and ask for permission if not permitted
        if self.locationManager.authorizationStatus != .authorizedAlways {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        /// Start updating heading if available
        if CLLocationManager.headingAvailable() {
            self.locationManager.startUpdatingHeading()
        }
        
        /// Start updating location if available
        self.locationManager.startUpdatingLocation()
    }
    
    /** On location authorization change */
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if self.locationManager.authorizationStatus == .authorizedAlways || self.locationManager.authorizationStatus == .authorizedWhenInUse {
            self.startLocationManager()
        }
    }
    
    /** On heading change */
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        /// Update the magnetic heading
        self.degrees = newHeading.magneticHeading
    }
    
    /** On location change */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            /// Update the current location
            self.currentLocation = location
            
            /// Check if this place is a new VisitedCity
            self.checkIfNewPlace(location: location)
        }
    }
    
    /**
     Check if the current location is a new city or not.
     
     - parameter location: CLLocation to check.
     */
    private func checkIfNewPlace(location: CLLocation) {
        if let startingPosition = startingPosition {
            /// Only on significant location change
            if startingPosition.distance(from: location) < 400 {
                return
            }
        }else{
            /// This is the first time this function has been called. Keep executing
            self.startingPosition = location
            self.significantLocationChange.send(true)
        }
        
        Task.init(priority: .utility) {
            /// Get a CLPlacemark for the specified location
            guard let placemark = await getPlacemarkFor(location: location) else {
                self.startingPosition = nil
                return
            }
            
            /// Get the locality name of the placemark
            guard let locality = placemark.locality else {
                self.startingPosition = nil
                return
            }
            
            /// Check if the locality is already present in the database
            let currentPlace = try? await AppDatabase.shared.databaseReader.read { db in
                try VisitedCity.filter(Column("name") == locality).fetchOne(db)
            }
            
            if currentPlace != nil {
                /// If the city is already present, return
                print("City already present. Skipping")
                self.currentCity = currentPlace
                return
            }
            
            print("New city! Let's add it")
            
            /// Since the user has never visited this city, create a new one and save it to the database
            var newCity = VisitedCity(name: locality, state: placemark.country ?? "-", image: "https://siviaggia.it/wp-content/uploads/sites/2/2020/08/innamorarsi-napoli.jpg")
            self.currentCity = newCity
            
            try? AppDatabase.shared.saveCity(&newCity)
        }
    }
    
    /**
     Get CLPlacemark for a specified CLLocation
     
     - parameter location: CLLocation.
     - returns: CLPlacemark of the specified location
     */
    private func getPlacemarkFor(location: CLLocation) async -> CLPlacemark? {
        let geoCoder = CLGeocoder()
        
        /// Async implementation of reverseGeocodeLocation function
        return await withCheckedContinuation({ continuation in
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                /// Return the CLPlacemark
                continuation.resume(returning: placeMark)
            })
        })
    }
    
    /**
     Search for POI
     
     - Parameters:
     - resultType: Type of search
     - text: Text to search
     - isWatch: If the results are for the watch or for the iOS app
     */
    public func search(for resultType: MKLocalSearch.ResultType = .pointOfInterest,
                       text: String,
                       isWatch: Bool = false) {
        print("search(text: \(text))")
        /// Instantiate MKLocalSearch.Request()
        let request = MKLocalSearch.Request()
        /// Set naturalLanguageQuery if the text is not empty
        if !text.isEmpty {
            request.naturalLanguageQuery = text
        }
        /// Set search parameters
        request.pointOfInterestFilter = .includingAll
        request.resultTypes = resultType
        
        guard let currentLocation = currentLocation else {
            /// If currentLocation is not set, send empty results
            self.sendToPublisher([], isWatch: isWatch)
            return
        }
        
        ///  Set the region of search around the user location
        request.region = MKCoordinateRegion(center: currentLocation.coordinate,
                                            latitudinalMeters: 30000,
                                            longitudinalMeters: 30000)
        
        /// Instantiate MKLocalSearch object
        let search = MKLocalSearch(request: request)
        
        /// Start the search with the request parameters
        search.start { [weak self](response, _) in
            guard let response = response else {
                /// Send empty results if  the response is empty
                self?.sendToPublisher([], isWatch: isWatch)
                return
            }
            
            /// Send results
            self?.sendToPublisher(response.mapItems, isWatch: isWatch)
        }
    }
    
    /** Send results to subscribers */
    private func sendToPublisher(_ value: [MKMapItem], isWatch: Bool = false) {
        if !isWatch {
            self.searchPublisher.send(value)
        }else{
            self.searchWatchPublisher.send(value)
        }
    }
}

