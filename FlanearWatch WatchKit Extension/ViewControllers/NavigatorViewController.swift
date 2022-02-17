//
//  NavigatorViewController.swift
//  FlanearWatch WatchKit Extension
//
//  Created by Mattia Fochesato on 17/02/22.
//

import Foundation
import WatchConnectivity
import CoreLocation

class NavigatorViewController: NSObject, ObservableObject, WCSessionDelegate, CLLocationManagerDelegate{
    var session: WCSession
    
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
            
            if let destinationDistance = destinationDistance {
                self.destinationDistance = destinationDistance
            }
            if !self.headingAvailable {
                if let degrees = degrees {
                    self.degrees = degrees
                }
            }else{
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("new heading: \(newHeading)")
        //self.degrees = -1 * newHeading + self.bearingDegrees
    }
    
}
