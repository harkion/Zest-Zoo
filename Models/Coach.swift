//
//  Coach.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI

enum Coach: String, Codable, CaseIterable {
    case koala
    case panda
    case squirrel

    var displayName: String {
        switch self {
        case .koala:    return "Coach Koala"
        case .panda:    return "Coach Panda"
        case .squirrel: return "Coach Squirrel"
        }
    }

    var nickname: String {
        switch self {
        case .koala:    return "Koa"
        case .panda:    return "Bo"
        case .squirrel: return "Zip"
        }
    }

    var emoji: String {
        switch self {
        case .koala:    return "🐨"
        case .panda:    return "🐼"
        case .squirrel: return "🐿️"
        }
    }

    // The accent color for each coach — matches your Figma exactly
    var primaryColor: Color {
        switch self {
        case .koala:    return Color(hex: "#8DA9C4") // muted blue-grey
        case .panda:    return Color(hex: "#4CAF50") // green
        case .squirrel: return Color(hex: "#FF9500") // orange
        }
    }

    var secondaryColor: Color {
        switch self {
        case .koala:    return Color(hex: "#E8EEF4")
        case .panda:    return Color(hex: "#E8F5E9")
        case .squirrel: return Color(hex: "#FFF3E0")
        }
    }

    // Currency name per coach
    var currencyName: String {
        switch self {
        case .koala:    return "Leafs"
        case .panda:    return "Bamboo"
        case .squirrel: return "Acorns"
        }
    }

    var currencyEmoji: String {
        switch self {
        case .koala:    return "🍃"
        case .panda:    return "🎋"
        case .squirrel: return "🌰"
        }
    }

    // Nudge messages shown in push notifications
    var nudgeMessages: [String] {
        switch self {
        case .koala:
            return [
                "Hey buddy… been sitting a while. Wanna join me for a 90-second shoulder roll?",
                "No pressure, but your neck might love a tiny stretch right now…",
                "I've been napping all morning. Maybe we both need a little shake?"
            ]
        case .panda:
            return [
                "Bamboo break time! Let's do 2 minutes of standing twists 🎋",
                "You've been at it for a while. Take 4 minutes. Your future self is rooting for you.",
                "Quick panda check-in — 3 minutes, that's it. You've got this."
            ]
        case .squirrel:
            return [
                "QUICK! 45 seconds of high knees, I'm already doing them! 🐿️",
                "47 minutes of sitting. You know what that does. 5 minutes. Right now. GO.",
                "4 minutes free? Let's burn it. Clock's ticking ⚡"
            ]
        }
    }

    // Greeting based on time of day
    func greeting(for hour: Int) -> String {
        let timeWord = hour < 12 ? "morning" : hour < 17 ? "afternoon" : "evening"
        switch self {
        case .koala:
            return "Good \(timeWord)… or whatever time it is. No judgment. I'm just glad you're here."
        case .panda:
            return "Good \(timeWord). Today we move a little. Nothing crazy — ready when you are."
        case .squirrel:
            return "Good \(timeWord). Here's today's plan. Takes 5 minutes. Let's move."
        }
    }

    // Coach tagline shown on home card
    var tagline: String {
        switch self {
        case .koala:    return "Ready for your next micro-movement?"
        case .panda:    return "Ready for your next micro-movement?"
        case .squirrel: return "Ready to burst? Let's go."
        }
    }
}
