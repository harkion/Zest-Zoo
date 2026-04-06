//
//  RootView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(AppState.self) private var appState
    @Query private var users: [User]

    var body: some View {
        Group {
            switch appState.appPhase {
            case .loading:
                SplashView()
                    .onAppear {
                        appState.currentUser = users.first
                        appState.determinePhase()
                    }
            case .onboarding:
                QuizView()
            case .mainApp:
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.4), value: appState.appPhase)
    }
}
