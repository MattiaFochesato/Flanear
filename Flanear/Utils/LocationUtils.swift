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
    @Published var currentPlace: VisitedPlace?
    
    let searchPublisher = PassthroughSubject<[MKMapItem], Never>()
    let searchWatchPublisher = PassthroughSubject<[MKMapItem], Never>()
    let significantLocationChange = PassthroughSubject<Bool, Never>()
    var startingPosition: CLLocation? = nil
    
    override init() {
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        super.init()
        
        self.locationManager.delegate = self
        self.startLocationManager()
    }
    
    //Setup CLLocationManager
    private func startLocationManager() {
        //Richiedi autorizzazione
        if self.locationManager.authorizationStatus != .authorizedAlways {
            self.locationManager.requestAlwaysAuthorization()
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
            self.significantLocationChange.send(true)
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
                       text: String, isWatch: Bool = false) {
        print("search(text: \(text))")
        let request = MKLocalSearch.Request()
        if !text.isEmpty {
            request.naturalLanguageQuery = text
        }
        request.pointOfInterestFilter = .includingAll
        request.resultTypes = resultType
        guard let currentLocation = currentLocation else {
            self.sendToPublisher([], isWatch: isWatch)
            return
        }
        
        request.region = MKCoordinateRegion(center: currentLocation.coordinate,
                                            latitudinalMeters: 30000,
                                            longitudinalMeters: 30000)
        
        let search = MKLocalSearch(request: request)
        
        search.start { [weak self](response, _) in
            guard let response = response else {
                self?.sendToPublisher([], isWatch: isWatch)
                return
            }
            
            self?.sendToPublisher(response.mapItems, isWatch: isWatch)
        }
    }
    
    func sendToPublisher(_ value: [MKMapItem], isWatch: Bool = false) {
        if !isWatch {
            self.searchPublisher.send(value)
        }else{
            self.searchWatchPublisher.send(value)
        }
    }
}

extension MKMapItem {
    
    func getPOIInfo() -> (String, String) {
        
        guard let pointOfInterestCategory = pointOfInterestCategory else {
            return ("undefined","questionmark.circle.fill")
        }
        
        switch pointOfInterestCategory {
            case .amusementPark:
                return ("amusementPark","t.circle")
            case .aquarium:
                return ("acquarium","t.circle")
            case .beach:
                return ("beach","t.circle")
            case .cafe:
                return ("cafe","t.circle")
            case .restaurant:
                return ("restourant","t.circle")
            case .publicTransport:
                return ("publicTransport", "tram.fill")
            default:
                return ("und: \(pointOfInterestCategory.rawValue)","t.circle")
        }
    }
    
}
