//
//  FlanearApp.swift
//  FlanearWatch WatchKit Extension
//
//  Created by Mattia Fochesato on 12/02/22.
//

import SwiftUI

@main
struct FlanearApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                TabView {
                    NavigatorView()
                    PickPlaceView()
                }
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
