//
//  Zest_ZooApp.swift
//  Zest Zoo
//
//  Created by Fahri Can on 24/03/2026.
//

import SwiftUI
import SwiftData

@main
struct Zest_ZooApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
        }
        .modelContainer(for: [User.self, ActivityRecord.self])
    }
}
