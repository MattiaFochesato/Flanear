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

class NavigatorViewController: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locations = [
        Location(name: "San Giorgio a Cremano", coordinate: CLLocationCoordinate2D(latitude: 40.829170, longitude: 14.334190)),
        Location(name: "Developer Academy", coordinate: CLLocationCoordinate2D(latitude: 40.836210, longitude: 14.306480))
        
    ]
    
    private var bearingDegrees: Double = .zero
    @Published var degrees: Double = .zero
    @Published var currentLocation: CLLocation?
    @Published var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 38.898150, longitude: -77.034340),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    @Published var destinationLocation: CLLocation? = CLLocation(latitude: 40.829170, longitude: 14.334190)
    @Published var destinationDistance: CLLocationDistance = 0
    @Published var destinationName: String = "San Giorgio a Cremano"
    
    private let locationManager: CLLocationManager
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
        self.degrees = -1 * newHeading.magneticHeading + bearingDegrees
    }
    
    //Location Change
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = location
            self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0007, longitudeDelta: 0.0007))
            
            //Update distance data
            self.bearingDegrees = getBearingBetween(point1: self.currentLocation!, point2: self.destinationLocation!)
            self.destinationDistance = self.currentLocation!.distance(from: self.destinationLocation!)
        }
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
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
