//
//  NavigatorViewController.swift
//  FlanearWatch WatchKit Extension
//
//  Created by Mattia Fochesato on 17/02/22.
//

import Foundation
import WatchConnectivity
import CoreLocation
import MapKit

class NavigatorViewController: NSObject, ObservableObject, WCSessionDelegate, CLLocationManagerDelegate{
    var session: WCSession
    
    @Published var selectedTab: Int = 0
    
    @Published var searchResults: [PlaceSearchItem]? = nil
    
    @Published var degrees: Double = .zero
    @Published var destinationLocation: CLLocation? = CLLocation(latitude: 40.829170, longitude: 14.334190)
    @Published var destinationDistance: CLLocationDistance = 0
    @Published var destinationName: String = "San Giorgio a Cremano"
    
    private let locationManager: CLLocationManager
    private var headingAvailable = false
    
    init(session: WCSession = .default){
        self.session = session
        self.locationManager = CLLocationManager()
        
        super.init()
        
        session.delegate = self
        session.activate()
        
        if CLLocationManager.headingAvailable() {
            self.locationManager.startUpdatingHeading()
            self.headingAvailable = true
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            let destinationDistance = message["distance"] as? CLLocationDistance
            let degrees = message["degrees"] as? Double
            let destinationName = message["destinationName"] as? String
            let searchResults = message["searchResults"] as? Data
            
            if let destinationName = destinationName {
                self.destinationName = destinationName
            }
            if let destinationDistance = destinationDistance {
                self.destinationDistance = destinationDistance
            }
            if !self.headingAvailable {
                if let degrees = degrees {
                    self.degrees = degrees
                }
            }else{
                
            }
            if let searchResults = searchResults {
                let decoder = JSONDecoder()
                
                if let decoded = try? decoder.decode([PlaceSearchItem].self, from: searchResults) {
                    self.searchResults = decoded
                }
            }
        }
    }
    
    func loadSuggestions() {
        searchResults = nil
        
        let dataToSend = ["loadSuggestions": "true"]

        self.session.sendMessage(dataToSend, replyHandler: nil, errorHandler: { error in
            print(error)
        })
    }
    
    func visit(place: PlaceSearchItem) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(place) {
            let dataToSend = ["visitNewPlace": encoded]

            session.sendMessage(dataToSend, replyHandler: nil, errorHandler: { error in
                print(error)
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("new heading: \(newHeading)")
        //self.degrees = -1 * newHeading + self.bearingDegrees
    }
    
}
