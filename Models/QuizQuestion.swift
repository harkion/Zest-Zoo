//
//  QuizQuestion.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import Foundation

struct QuizOption: Identifiable {
    let id = UUID()
    let text: String
    let points: Int           // 0 = active, 3 = laziest
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [QuizOption]
    let section: QuizSection
}

enum QuizSection {
    case lazinessScore      // Q1–5: used for coach assignment
    case personalisation    // Q6–8: used to tailor activities
}

extension QuizQuestion {
    static let all: [QuizQuestion] = [

        // --- SECTION 1: Coach Assignment ---
        QuizQuestion(
            question: "How many hours per day do you usually sit without standing?",
            options: [
                QuizOption(text: "0–4 hours",  points: 0),
                QuizOption(text: "4–8 hours",  points: 1),
                QuizOption(text: "8–12 hours", points: 2),
                QuizOption(text: "12+ hours",  points: 3)
            ],
            section: .lazinessScore
        ),

        QuizQuestion(
            question: "When you've been sitting a long time, how do you feel about a 5-minute movement break?",
            options: [
                QuizOption(text: "I jump at the chance",       points: 0),
                QuizOption(text: "I'll do it if it's easy",   points: 1),
                QuizOption(text: "Only if I'm really nagged", points: 2),
                QuizOption(text: "I usually ignore it",        points: 3)
            ],
            section: .lazinessScore
        ),

        QuizQuestion(
            question: "How many times per week do you already exercise (even just walking)?",
            options: [
                QuizOption(text: "5+ times",  points: 0),
                QuizOption(text: "3–4 times", points: 1),
                QuizOption(text: "1–2 times", points: 2),
                QuizOption(text: "Never",     points: 3)
            ],
            section: .lazinessScore
        ),

        QuizQuestion(
            question: "How do you usually feel at 3pm?",
            options: [
                QuizOption(text: "Still energetic",  points: 0),
                QuizOption(text: "Okay but tired",   points: 1),
                QuizOption(text: "Pretty drained",   points: 2),
                QuizOption(text: "Full zombie mode", points: 3)
            ],
            section: .lazinessScore
        ),

        QuizQuestion(
            question: "If your coach texted you right now to stand for 60 seconds — would you do it?",
            options: [
                QuizOption(text: "100% yes",  points: 0),
                QuizOption(text: "Probably",  points: 1),
                QuizOption(text: "Maybe",     points: 2),
                QuizOption(text: "Hard no",   points: 3)
            ],
            section: .lazinessScore
        ),

        // --- SECTION 2: Personalisation only (no points) ---
        QuizQuestion(
            question: "What's your biggest health/lifestyle struggle right now?",
            options: [
                QuizOption(text: "Back or neck pain from sitting", points: 0),
                QuizOption(text: "Low energy all day",             points: 0),
                QuizOption(text: "Trouble focusing",               points: 0),
                QuizOption(text: "Feeling stiff",                  points: 0),
                QuizOption(text: "Want to lose a few pounds",      points: 0),
                QuizOption(text: "Just want any movement habit",   points: 0)
            ],
            section: .personalisation
        ),

        QuizQuestion(
            question: "What's your main intention with the app?",
            options: [
                QuizOption(text: "Feel less tired during work or study",       points: 0),
                QuizOption(text: "Improve my posture",                         points: 0),
                QuizOption(text: "Build a tiny daily habit",                   points: 0),
                QuizOption(text: "Lightweight weight management",              points: 0),
                QuizOption(text: "Reduce stress",                              points: 0),
                QuizOption(text: "Move more without it feeling like exercise", points: 0)
            ],
            section: .personalisation
        ),

        QuizQuestion(
            question: "How much time can you honestly spare per day?",
            options: [
                QuizOption(text: "1–2 minutes total",              points: 0),
                QuizOption(text: "3–5 minutes total",              points: 0),
                QuizOption(text: "5–10 minutes total",             points: 0),
                QuizOption(text: "Whatever the coach says",        points: 0)
            ],
            section: .personalisation
        )
    ]
}
