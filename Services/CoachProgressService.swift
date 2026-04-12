//
//  CoachProgressService.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import Foundation
import SwiftData

class CoachProgressService {
    static let shared = CoachProgressService()
    private init() {}

    // Thresholds for promotion
    private let activitiesForPromotion = 20
    private let streakForPromotion = 14
    private let activitiesForDemotion = 3    // less than this in a week → consider demotion
    private let missedDaysForDemotion = 5

    // MARK: - Check if user should be promoted or demoted
    func evaluateCoachChange(for user: User) -> CoachTransition? {

        // --- Promotion logic ---
        if shouldPromote(user: user) {
            switch user.assignedCoach {
            case .koala:
                return CoachTransition(
                    from: .koala,
                    to: .panda,
                    type: .promotion,
                    message: promotionMessage(from: .koala, to: .panda)
                )
            case .panda:
                return CoachTransition(
                    from: .panda,
                    to: .squirrel,
                    type: .promotion,
                    message: promotionMessage(from: .panda, to: .squirrel)
                )
            case .squirrel:
                return nil // Already at highest tier
            }
        }

        // --- Demotion logic ---
        if shouldDemote(user: user) {
            switch user.assignedCoach {
            case .squirrel:
                return CoachTransition(
                    from: .squirrel,
                    to: .panda,
                    type: .demotion,
                    message: demotionMessage(from: .squirrel, to: .panda)
                )
            case .panda:
                return CoachTransition(
                    from: .panda,
                    to: .koala,
                    type: .demotion,
                    message: demotionMessage(from: .panda, to: .koala)
                )
            case .koala:
                return nil // Already at lowest tier
            }
        }

        return nil
    }

    // MARK: - Apply the transition
    func applyTransition(_ transition: CoachTransition, to user: User, context: ModelContext) {
        user.assignedCoach = transition.to
        // Reset weekly counters after coach change
        user.weeklyMinutes = 0
        user.dailySessionsCompleted = 0
        try? context.save()

        // Reschedule notifications for new coach
        let nudgeTimes = NudgeTime.defaults
        NotificationService.shared.scheduleDailyNudges(
            for: transition.to,
            times: nudgeTimes
        )
    }

    // MARK: - Promotion conditions
    private func shouldPromote(user: User) -> Bool {
        // Must have completed enough total activities
        // AND maintained a streak
        return user.totalActivitiesCompleted >= activitiesForPromotion
            && user.currentStreak >= streakForPromotion
    }

    // MARK: - Demotion conditions
    private func shouldDemote(user: User) -> Bool {
        // Only consider demotion if there's meaningful history
        guard user.totalActivitiesCompleted > 5 else { return false }

        // Check if streak has collapsed
        let streakBroken = user.currentStreak == 0

        // Check last active date — if more than 5 days ago
        let daysSinceActive: Int
        if let last = user.lastActiveDate {
            daysSinceActive = Calendar.current.dateComponents(
                [.day], from: last, to: Date()
            ).day ?? 0
        } else {
            daysSinceActive = 0
        }

        return streakBroken && daysSinceActive >= missedDaysForDemotion
    }

    // MARK: - Transition messages
    private func promotionMessage(from: Coach, to: Coach) -> TransitionMessage {
        switch (from, to) {
        case (.koala, .panda):
            return TransitionMessage(
                fromCoachLine: "Something's different about you lately. You keep showing up. I noticed.",
                bridgeLine: "I think you're ready for someone who can match that energy.",
                toCoachLine: "His name is Bo. He's a little more structured than me, but he's good. Really good.",
                farewell: "Come back and visit sometime. I'll be right here. 🐨",
                objectPassed: "eucalyptus leaf"
            )
        case (.panda, .squirrel):
            return TransitionMessage(
                fromCoachLine: "I've been watching your data. You've stopped just completing activities — you're anticipating them.",
                bridgeLine: "There's someone who moves at your speed now.",
                toCoachLine: "Zip. She's a lot. But so are you, apparently.",
                farewell: "Don't forget the slow stuff. It matters too. 🐼",
                objectPassed: "bamboo flag"
            )
        default:
            return TransitionMessage(
                fromCoachLine: "You've grown so much.",
                bridgeLine: "Time for the next level.",
                toCoachLine: "Your new coach is ready for you.",
                farewell: "Keep going.",
                objectPassed: ""
            )
        }
    }

    private func demotionMessage(from: Coach, to: Coach) -> TransitionMessage {
        switch (from, to) {
        case (.squirrel, .panda):
            return TransitionMessage(
                fromCoachLine: "Hey. Real talk. Your body's telling you something and you're not wrong to listen.",
                bridgeLine: "Rest is data too.",
                toCoachLine: "Bo's going to take care of you. Structured, steady, no nonsense.",
                farewell: "When you're ready to run again, I'll be here. 🐿️",
                objectPassed: "stopwatch"
            )
        case (.panda, .koala):
            return TransitionMessage(
                fromCoachLine: "We've been pushing. Maybe too much — that's on me too.",
                bridgeLine: "Koa has this thing. She makes you feel okay about being human.",
                toCoachLine: "You need that right now more than reps.",
                farewell: "This isn't going backward. This is knowing yourself. That's advanced. 🐼",
                objectPassed: "bamboo shoot"
            )
        default:
            return TransitionMessage(
                fromCoachLine: "It's okay to slow down.",
                bridgeLine: "Recovery is part of the journey.",
                toCoachLine: "Your new coach will take good care of you.",
                farewell: "We'll pick this back up.",
                objectPassed: ""
            )
        }
    }
}

// MARK: - Supporting Models
struct CoachTransition {
    let from: Coach
    let to: Coach
    let type: TransitionType
    let message: TransitionMessage

    enum TransitionType {
        case promotion
        case demotion
    }
}

struct TransitionMessage {
    let fromCoachLine: String
    let bridgeLine: String
    let toCoachLine: String
    let farewell: String
    let objectPassed: String
}
