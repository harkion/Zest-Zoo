//
//  NotificationService.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//


// Two trigger types will come:
// 1. Scheduled — user-set times (e.g., 10am, 2pm, 4pm)
// 2. Inactivity-based — CMMotionActivityManager detects 45+ min sitting

import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    private init() {}

    // MARK: - Permission
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            return granted
        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }

    // MARK: - Schedule daily nudges
    func scheduleDailyNudges(for coach: Coach, times: [NudgeTime]) {
        // Clear existing before rescheduling
        cancelAllNudges()

        for nudgeTime in times {
            guard nudgeTime.isEnabled else { continue }

            let message = coach.nudgeMessages.randomElement()
                ?? coach.nudgeMessages[0]

            let content = UNMutableNotificationContent()
            content.title = "\(coach.emoji) \(coach.nickname) says..."
            content.body = message
            content.sound = .default
            content.badge = 1

            var dateComponents = DateComponents()
            dateComponents.hour = nudgeTime.hour
            dateComponents.minute = nudgeTime.minute

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )

            let request = UNNotificationRequest(
                identifier: "nudge_\(nudgeTime.id)",
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request) { error in
                if let error {
                    print("Failed to schedule nudge: \(error)")
                }
            }
        }
    }

    // MARK: - Schedule inactivity nudge
    // Called when MotionService detects 45+ min of inactivity
    func scheduleInactivityNudge(for coach: Coach, afterMinutes: Int = 45) {
        let content = UNMutableNotificationContent()
        content.title = "\(coach.emoji) \(coach.nickname) is checking in…"
        content.body = coach.nudgeMessages.randomElement() ?? coach.nudgeMessages[0]
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(afterMinutes * 60),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "inactivity_nudge",
            content: content,
            trigger: trigger
        )

        // Cancel any existing inactivity nudge first
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["inactivity_nudge"])

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Failed to schedule inactivity nudge: \(error)")
            }
        }
    }

    // MARK: - Weekly summary (every Sunday 7pm)
    func scheduleWeeklySummary(for coach: Coach) {
        let content = UNMutableNotificationContent()
        content.title = "Your weekly recap is ready \(coach.emoji)"
        content.body = "\(coach.nickname) has your movement summary for the week. Come see how far you've come!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.weekday = 1  // Sunday
        dateComponents.hour = 19
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "weekly_summary",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Failed to schedule weekly summary: \(error)")
            }
        }
    }

    // MARK: - Cancel
    func cancelAllNudges() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    func cancelInactivityNudge() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["inactivity_nudge"])
    }
}

// MARK: - Nudge Time Model
struct NudgeTime: Identifiable, Codable {
    let id: String
    var hour: Int
    var minute: Int
    var isEnabled: Bool
    var label: String

    static let defaults: [NudgeTime] = [
        NudgeTime(id: "morning",   hour: 9,  minute: 0, isEnabled: true,  label: "Morning"),
        NudgeTime(id: "afternoon", hour: 14, minute: 0, isEnabled: true,  label: "Afternoon"),
        NudgeTime(id: "evening",   hour: 18, minute: 0, isEnabled: false, label: "Evening")
    ]
}
