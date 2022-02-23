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
            TabView {
                NavigatorView()
                    .tabItem {
                        Label("Explore", systemImage: "map.fill")
                    }
                CitiesView()
                    .tabItem {
                        Label("Your Cities", systemImage: "book.closed.fill")
                    }
            }
        }
    }
}
