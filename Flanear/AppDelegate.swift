//
//  AppDelegate.swift
//  Flanear
//
//  Created by Mattia Fochesato on 23/02/22.
//

import Foundation
import UIKit
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        GMSPlacesClient.provideAPIKey("YOUR_API_KEY")
        
        return true
    }
}
