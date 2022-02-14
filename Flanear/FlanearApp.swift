//
//  FlanearApp.swift
//  Flanear
//
//  Created by Mattia Fochesato on 11/02/22.
//

import SwiftUI

@main
struct FlanearApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigatorView()
                    .tabItem {
                        Label("Explore", systemImage: "map.fill")
                    }
                DiaryView()
                    .tabItem {
                        Label("Diary", systemImage: "book.closed.fill")
                    }
            }
        }
    }
}
