//
//  AppState.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI

@Observable
class AppState {
    var hasCompletedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") }
        set { UserDefaults.standard.set(newValue, forKey: "hasCompletedOnboarding") }
    }

    var currentUser: User?
    var appPhase: AppPhase = .loading

    enum AppPhase {
        case loading
        case onboarding
        case mainApp
    }

    func determinePhase(users: [User]) {
        // Always check BOTH conditions using the live users array
        // not a cached currentUser that might be stale
        if let user = users.first, user.hasCompletedOnboarding {
            currentUser = user
            appPhase = .mainApp
        } else {
            // Clear any stale data
            currentUser = nil
            hasCompletedOnboarding = false
            appPhase = .onboarding
        }
    }
}
