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
            /// Flanear View Holder
            FlanearViewHolder()
        }
    }
}

struct FlanearViewHolder: View {
    @Environment(\.scenePhase) var scenePhase

    @ObservedObject var viewController = NavigatorViewController()
    @ObservedObject var searchViewController = PlaceSearchViewController()

    var body: some View {
        NavigatorView()
            .environmentObject(viewController)
            .environmentObject(searchViewController)
            .onChange(of: scenePhase) { newPhase in
                viewController.onChange(of: newPhase)
            }
    }
}
