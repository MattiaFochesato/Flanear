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
    @Published var showSearch = false
    
    var degreesCancellable: AnyCancellable? = nil
    var positionCancellable: AnyCancellable? = nil
    
    var session: WCSession?
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            session = .default
            session?.delegate = self
            session?.activate()
        }
        
        self.degreesCancellable = LocationUtils.shared.$degrees.sink { newVal in
            self.degrees = -1 * newVal + self.bearingDegrees
        }
        
        self.positionCancellable = LocationUtils.shared.$currentLocation.sink(receiveValue: { location in
            self.currentLocation = location
            
            guard let location = location else { return }
            
            self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0007, longitudeDelta: 0.0007))
            
            //Update distance data
            self.bearingDegrees = self.getBearingBetween(point1: self.currentLocation!, point2: self.destinationLocation!)
            self.destinationDistance = self.currentLocation!.distance(from: self.destinationLocation!)
            
            if let validSession = self.session {
                let dataToSend = ["distance": self.destinationDistance, "degrees": self.bearingDegrees]

                validSession.sendMessage(dataToSend, replyHandler: nil, errorHandler: { error in
                    print(error)
                })
            }
            
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
}

extension NavigatorViewController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
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
