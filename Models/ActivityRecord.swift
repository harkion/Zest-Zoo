//
//  ActivityRecord.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import Foundation
import SwiftData

// Each completed movement session stored to disk
@Model
class ActivityRecord {
    var id: UUID
    var activityName: String
    var coach: Coach
    var durationSeconds: Int
    var currencyEarned: Int
    var completedAt: Date

    init(activityName: String, coach: Coach, durationSeconds: Int, currencyEarned: Int) {
        self.id = UUID()
        self.activityName = activityName
        self.coach = coach
        self.durationSeconds = durationSeconds
        self.currencyEarned = currencyEarned
        self.completedAt = Date()
    }
}
