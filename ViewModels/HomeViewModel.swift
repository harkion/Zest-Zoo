//
//  HomeViewModel.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI
import SwiftData

@Observable
class HomeViewModel {
    var user: User

    init(user: User) {
        self.user = user
    }

    var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good Morning" }
        else if hour < 17 { return "Good Afternoon" }
        else { return "Good Evening" }
    }

    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }

    var weeklyProgressPercent: Double {
        guard user.weeklyGoalMinutes > 0 else { return 0 }
        return min(Double(user.weeklyMinutes) / Double(user.weeklyGoalMinutes), 1.0)
    }

    var minutesToGoal: Int {
        max(user.weeklyGoalMinutes - user.weeklyMinutes, 0)
    }

    var dailyProgressText: String {
        "\(user.dailySessionsCompleted)/\(user.dailySessionGoal)"
    }

    var motivationalBanner: String? {
        let remaining = user.dailySessionGoal - user.dailySessionsCompleted
        if remaining <= 0 {
            return "🎉 Daily goal crushed! \(user.assignedCoach.nickname) is proud."
        } else if user.dailySessionsCompleted > 0 {
            return "\(remaining) more to hit your daily goal!"
        }
        return nil
    }

    // Random activity from coach's list
    var todaysActivity: Activity {
        let list = Activity.activities(for: user.assignedCoach)
        return list.randomElement() ?? list[0]
    }

    func completeSession(activity: Activity, context: ModelContext) {
        let minutesEarned = activity.duration / 60
        let currencyEarned = 15 + (minutesEarned * 5)

        user.dailySessionsCompleted += 1
        user.totalActivitiesCompleted += 1
        user.weeklyMinutes += minutesEarned
        user.totalMinutes += minutesEarned
        user.currencyBalance += currencyEarned
        user.lastActiveDate = Date()

        updateStreak()

        let record = ActivityRecord(
            activityName: activity.name,
            coach: user.assignedCoach,
            durationSeconds: activity.duration,
            currencyEarned: currencyEarned
        )
        context.insert(record)
        try? context.save()
    }

    private func updateStreak() {
        guard let last = user.lastActiveDate else {
            user.currentStreak = 1
            return
        }
        let daysSince = Calendar.current.dateComponents(
            [.day], from: last, to: Date()
        ).day ?? 0

        if daysSince == 1 {
            user.currentStreak += 1
        } else if daysSince > 1 {
            user.currentStreak = 1
        }
    }
}
