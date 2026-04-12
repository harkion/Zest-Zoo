//
//  QuizViewModel.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI
import SwiftData

@Observable
class QuizViewModel {
    let questions = QuizQuestion.all
    var selectedOptions: [Int: Int] = [:]
    var currentQuestionIndex: Int = 0

    var isComplete: Bool {
        selectedOptions.count == questions.count
    }

    var progress: Double {
        Double(currentQuestionIndex + 1) / Double(questions.count)
    }

    func select(optionIndex: Int, for questionIndex: Int) {
        selectedOptions[questionIndex] = optionIndex
    }

    func advance() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        }
    }

    func goBack() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }

    func assignedCoach() -> Coach {
        let score = lazinessScore()
        switch score {
        case 0...5:  return .squirrel
        case 6...10: return .panda
        default:     return .koala
        }
    }

    private func lazinessScore() -> Int {
        var total = 0
        for i in 0..<5 {
            if let selected = selectedOptions[i] {
                total += questions[i].options[selected].points
            }
        }
        return total
    }

    func primaryStruggle() -> String {
        guard let idx = selectedOptions[5] else { return "" }
        return questions[5].options[idx].text
    }

    func mainIntention() -> String {
        guard let idx = selectedOptions[6] else { return "" }
        return questions[6].options[idx].text
    }

    func dailyTimeCommitment() -> Int {
        guard let idx = selectedOptions[7] else { return 5 }
        switch idx {
        case 0: return 2
        case 1: return 5
        case 2: return 10
        default: return 5
        }
    }

    func createUser(context: ModelContext) -> User {
        let user = User(
            assignedCoach: assignedCoach(),
            dailySessionGoal: dailySessionGoal(),
            weeklyGoalMinutes: weeklyGoalMinutes(),
            primaryStruggle: primaryStruggle(),
            mainIntention: mainIntention(),
            dailyTimeCommitment: dailyTimeCommitment()
        )
        // This is the critical flag RootView checks
        user.hasCompletedOnboarding = true
        context.insert(user)
        try? context.save()
        return user
    }

    private func dailySessionGoal() -> Int {
        switch dailyTimeCommitment() {
        case 2:  return 1
        case 5:  return 3
        case 10: return 5
        default: return 3
        }
    }

    private func weeklyGoalMinutes() -> Int {
        dailyTimeCommitment() * 7
    }
}
