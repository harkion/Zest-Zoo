//
//  MotionService.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import Foundation
import CoreMotion

class MotionService {
    static let shared = MotionService()
    private init() {}

    private let activityManager = CMMotionActivityManager()
    private var inactivityTimer: Timer?
    private var lastMotionTime: Date = Date()
    private let inactivityThresholdMinutes: Double = 45

    var onInactivityDetected: ((Coach) -> Void)?
    
    
    // MARK: - Start monitoring
    func startMonitoring(for coach: Coach) {
        guard CMMotionActivityManager.isActivityAvailable() else {
            print("Motion activity not available on this device")
            scheduleTimerFallback(for: coach)
            return
        }

        activityManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let self, let activity else { return }

            let isMoving = activity.walking
                || activity.running
                || activity.cycling
                || activity.automotive

            if isMoving {
                self.lastMotionTime = Date()
                self.resetInactivityTimer(for: coach)
                NotificationService.shared.cancelInactivityNudge()
            } else {
                // Stationary — check how long
                let minutesSinceMotion = Date()
                    .timeIntervalSince(self.lastMotionTime) / 60

                if minutesSinceMotion >= self.inactivityThresholdMinutes {
                    self.onInactivityDetected?(coach)
                    NotificationService.shared.scheduleInactivityNudge(
                        for: coach,
                        afterMinutes: 1 // fires in 1 min after threshold hit
                    )
                    // Reset so it doesn't fire repeatedly
                    self.lastMotionTime = Date()
                }
            }
        }
    }

    func stopMonitoring() {
        activityManager.stopActivityUpdates()
        inactivityTimer?.invalidate()
        inactivityTimer = nil
    }

    // MARK: - Timer fallback (simulator / older devices)
    
    private func scheduleTimerFallback(for coach: Coach) {
        inactivityTimer?.invalidate()
        inactivityTimer = Timer.scheduledTimer(
            withTimeInterval: inactivityThresholdMinutes * 60,
            repeats: true
        ) { [weak self] _ in
            self?.onInactivityDetected?(coach)
            NotificationService.shared.scheduleInactivityNudge(for: coach, afterMinutes: 1)
        }
    }

    private func resetInactivityTimer(for coach: Coach) {
        inactivityTimer?.invalidate()
        scheduleTimerFallback(for: coach)
    }
}
