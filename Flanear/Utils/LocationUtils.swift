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

class LocationUtils: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = LocationUtils()
    
    private let locationManager: CLLocationManager
    @Published var degrees: Double = .zero
    @Published var currentLocation: CLLocation?
    @Published var currentCity: VisitedCity?
    
    let searchPublisher = PassthroughSubject<[MKMapItem], Never>()
    var startingPosition: CLLocation? = nil
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
        self.startLocationManager()
    }
    
    //Setup CLLocationManager
    private func startLocationManager() {
        //Richiedi autorizzazione
        if self.locationManager.authorizationStatus != .authorizedWhenInUse {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.headingAvailable() {
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }
    }
    
    //Bussola cambia
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.degrees = newHeading.magneticHeading
    }
    
    //Location Change
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
            
            self.checkIfNewPlace(location: location)
        }
    }
    
    func checkIfNewPlace(location: CLLocation) {
        if let startingPosition = startingPosition {
            //Only on significant location change
            if startingPosition.distance(from: location) < 400 {
                return
            }
        }else{
            self.startingPosition = location
        }
        
        Task.init(priority: .utility) {
            guard let placemark = await getPlacemarkFor(location: location) else {
                self.startingPosition = nil
                return
            }
            
            guard let locality = placemark.locality else {
                self.startingPosition = nil
                return
            }
            
            let currentPlace = try? await AppDatabase.shared.databaseReader.read { db in
                try VisitedCity.filter(Column("name") == locality).fetchOne(db)
            }
            
            if currentPlace != nil {
                print("City already present. Skipping")
                self.currentCity = currentPlace
                return
            }
            
            print("New city! Let's add it")
            
            var newCity = VisitedCity(name: locality, state: placemark.country ?? "-", image: "https://siviaggia.it/wp-content/uploads/sites/2/2020/08/innamorarsi-napoli.jpg")
            self.currentCity = newCity
            
            try? AppDatabase.shared.saveCity(&newCity)
            
        }
    }
    
    func getPlacemarkFor(location: CLLocation) async -> CLPlacemark? {
        let geoCoder = CLGeocoder()
        
        return await withCheckedContinuation({ continuation in
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                continuation.resume(returning: placeMark)
                
            })
        })
    }
    
    public func search(for resultType: MKLocalSearch.ResultType = .pointOfInterest,
                         text: String) {
        print("search(text: \(text))")
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.pointOfInterestFilter = .includingAll
        request.resultTypes = resultType
        request.region = MKCoordinateRegion(center: self.currentLocation!.coordinate,
                                            latitudinalMeters: 2500,
                                            longitudinalMeters: 2500)
        let search = MKLocalSearch(request: request)
        
        search.start { [weak self](response, _) in
            guard let response = response else {
                return
            }
            
            self?.searchPublisher.send(response.mapItems)
        }
    }
}
