//
//  FlanearApp.swift
//  Flanear
//
//  Created by Mattia Fochesato on 11/02/22.
//

import SwiftUI

@main
struct FlanearApp: App {
    /// App Delegate Adaptor
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    /// Main Window Scene
    var body: some Scene {
        WindowGroup {
            TabView {
                /// Navigator View with the Map
                NavigatorView()
                    .tabItem {
                        Label("explore", systemImage: "map.fill")
                    }
                /// Cities View with the list of visited cities
                CitiesView()
                    .tabItem {
                        Label("your-cities", systemImage: "book.closed.fill")
                    }
            }
        }
    }
}
