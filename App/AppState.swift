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

    func determinePhase() {
        if hasCompletedOnboarding && currentUser != nil {
            appPhase = .mainApp
        } else {
            appPhase = .onboarding
        }
    }
}
