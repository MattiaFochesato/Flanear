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
        //Initialize Google Places API with API Key
        //GMSPlacesClient.provideAPIKey("YOUR_API_KEY")
        
        //Updates the current version in the UserDefaults to show the updated data in the Settings.bundle
        UserDefaults.standard.set(
            Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String,
            forKey: "version_preference")
        UserDefaults.standard.set(
            Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String,
            forKey: "build_preference")
        
        //Initialization successful
        return true
    }
}
