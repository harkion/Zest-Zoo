//
//  User.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import Foundation
import SwiftData

@Model
class User {
    var id: UUID
    var name: String
    var assignedCoach: Coach
    var currentStreak: Int
    var totalMinutes: Int
    var weeklyMinutes: Int
    var weeklyGoalMinutes: Int
    var dailySessionsCompleted: Int
    var dailySessionGoal: Int
    var currencyBalance: Int          // Leafs / Bamboo / Acorns
    var totalActivitiesCompleted: Int
    var lastActiveDate: Date?
    var hasCompletedOnboarding: Bool
    var joinDate: Date

    // Goals from Q6–Q7 (personalisation, not assignment)
    var primaryStruggle: String
    var mainIntention: String
    var dailyTimeCommitment: Int      // minutes

    init(
        name: String = "",
        assignedCoach: Coach = .koala,
        dailySessionGoal: Int = 3,
        weeklyGoalMinutes: Int = 150,
        primaryStruggle: String = "",
        mainIntention: String = "",
        dailyTimeCommitment: Int = 5
    ) {
        self.id = UUID()
        self.name = name
        self.assignedCoach = assignedCoach
        self.currentStreak = 0
        self.totalMinutes = 0
        self.weeklyMinutes = 0
        self.weeklyGoalMinutes = weeklyGoalMinutes
        self.dailySessionsCompleted = 0
        self.dailySessionGoal = dailySessionGoal
        self.currencyBalance = 0
        self.totalActivitiesCompleted = 0
        self.lastActiveDate = nil
        self.hasCompletedOnboarding = false
        self.joinDate = Date()
        self.primaryStruggle = primaryStruggle
        self.mainIntention = mainIntention
        self.dailyTimeCommitment = dailyTimeCommitment
    }
}
