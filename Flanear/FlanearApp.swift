//
//  FlanearApp.swift
//  Flanear
//
//  Created by Mattia Fochesato on 11/02/22.
//

import SwiftUI

@main
struct FlanearApp: App {
    //App Delegate Adaptor
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    //Main Window Scene
    var body: some Scene {
        WindowGroup {
            //Navigator View with the Map
            NavigatorView()
        }
    }
}
