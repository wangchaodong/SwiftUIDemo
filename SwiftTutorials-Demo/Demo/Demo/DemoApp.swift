//
//  DemoApp.swift
//  Demo
//
//  Created by s1mple wang on 2022/7/5.
//

import SwiftUI

@main
struct DemoApp: App {
    @StateObject var modelData: ModelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
#if !os(watchOS)
        .commands {
            LandmarkCommands()
        }
#endif
#if os(watchOS)
        WKNotificationScene(controller: NotificationController.self, category: "LandmarkNear")
#endif

#if os(macOS)
        Settings {
            LandmarkSettings()
        }
#endif

    }
}
