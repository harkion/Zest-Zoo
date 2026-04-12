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
                // once SwiftData has populated `users`
                SplashView()

            case .onboarding:
                QuizView()

            case .mainApp:
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.4), value: appState.appPhase)
        // when SwiftData finishes its first load
        .onChange(of: users) { _, newUsers in
            if appState.appPhase == .loading {
                appState.determinePhase(users: newUsers)
            }
        }

        .onAppear {
            // Small delay to let SwiftData settle
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                if appState.appPhase == .loading {
                    appState.determinePhase(users: users)
                }
            }
        }
    }
}
