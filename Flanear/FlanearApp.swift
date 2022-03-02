//
//  FlanearApp.swift
//  Flanear
//
//  Created by Mattia Fochesato on 11/02/22.
//

import SwiftUI

@main
struct FlanearApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigatorView()
            /*TabView {
                NavigatorView()
                    .tabItem {
                        Label("explore", systemImage: "map.fill")
                    }
                CitiesView()
                    .tabItem {
                        Label("your-cities", systemImage: "book.closed.fill")
                    }
            }*/
        }
    }
}
