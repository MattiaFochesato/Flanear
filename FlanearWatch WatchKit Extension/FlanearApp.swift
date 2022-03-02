//
//  FlanearApp.swift
//  FlanearWatch WatchKit Extension
//
//  Created by Mattia Fochesato on 12/02/22.
//

import SwiftUI

@main
struct FlanearApp: App {
    @ObservedObject var viewController = NavigatorViewController()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                TabView(selection: $viewController.selectedTab) {
                    NavigatorView()
                        .tag(0)
                    PickPlaceView()
                        .tag(1)
                }
            }.environmentObject(viewController)
        }
        
        //WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
