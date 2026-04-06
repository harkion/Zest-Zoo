//
//  Activity.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import Foundation

struct Activity: Identifiable, Codable {
    let id: UUID
    let name: String
    let duration: Int        // seconds
    let description: String
    let coach: Coach

    static let koalaActivities: [Activity] = [
        Activity(id: UUID(), name: "Sleepy Neck Rolls",
                 duration: 90,
                 description: "Slowly roll your neck in a full circle, each direction. Close your eyes if you want.",
                 coach: .koala),
        Activity(id: UUID(), name: "Koala Shoulder Roll",
                 duration: 60,
                 description: "Roll both shoulders forward 5 times, then backward 5 times. Feel that crunch melt away.",
                 coach: .koala),
        Activity(id: UUID(), name: "The Big Exhale",
                 duration: 60,
                 description: "Breathe in slowly for 4 counts, hold for 4, out for 6. Repeat. That's it.",
                 coach: .koala),
        Activity(id: UUID(), name: "Wrist Wake-Up",
                 duration: 60,
                 description: "Rotate both wrists clockwise 10 times, then counter-clockwise. Desk hands rejoice.",
                 coach: .koala),
        Activity(id: UUID(), name: "Seated Spinal Twist",
                 duration: 120,
                 description: "Sit up, place right hand on left knee, twist gently. Hold 20 sec. Switch sides.",
                 coach: .koala),
        Activity(id: UUID(), name: "Ankle Alphabet",
                 duration: 120,
                 description: "Lift one foot and draw the alphabet with your toes. Switch feet. Weird? Yes. Good? Also yes.",
                 coach: .koala),
        Activity(id: UUID(), name: "The Slow Stand",
                 duration: 60,
                 description: "Stand up slowly from your chair. Hold for 5 seconds. Sit back down. Do this 3 times.",
                 coach: .koala),
        Activity(id: UUID(), name: "Eye Rest Reset",
                 duration: 60,
                 description: "Look at something 20 feet away for 20 seconds. Blink slowly. Your eyes needed this.",
                 coach: .koala),
        Activity(id: UUID(), name: "Desk Cat-Cow",
                 duration: 120,
                 description: "Seated: arch your back (cow), then round it (cat). 10 reps. Spine says thank you.",
                 coach: .koala),
        Activity(id: UUID(), name: "Gentle Side Stretch",
                 duration: 90,
                 description: "Reach one arm overhead and lean to the side. Hold 15 sec each side. Breathe.",
                 coach: .koala)
    ]

    static let pandaActivities: [Activity] = [
        Activity(id: UUID(), name: "Standing Desk Reset",
                 duration: 180,
                 description: "Stand, march in place for 60 sec, arm circles for 60 sec, shake everything out.",
                 coach: .panda),
        Activity(id: UUID(), name: "Panda Squat Flow",
                 duration: 240,
                 description: "Wide stance squat, lower slowly, hold 2 sec at the bottom. 10 reps. You're a panda now.",
                 coach: .panda),
        Activity(id: UUID(), name: "Wall Sit Hold",
                 duration: 180,
                 description: "Back against wall, slide down to 90°. Hold 30 sec. Rest. Repeat 3 times.",
                 coach: .panda),
        Activity(id: UUID(), name: "Hip Flexor Wake-Up",
                 duration: 240,
                 description: "Step one foot forward into a low lunge. Hold 30 sec per side. Your hips have been waiting.",
                 coach: .panda),
        Activity(id: UUID(), name: "Panda Push Circuit",
                 duration: 300,
                 description: "10 wall push-ups, 10 countertop push-ups. Rest 30 sec. Repeat twice. Bro mode: activated.",
                 coach: .panda),
        Activity(id: UUID(), name: "The Bamboo Walk",
                 duration: 240,
                 description: "Walk around your space with perfect posture. Chin up, shoulders back, 4 minutes. You're majestic.",
                 coach: .panda),
        Activity(id: UUID(), name: "Calf Raise Sequence",
                 duration: 180,
                 description: "Standing at your desk: rise onto your toes, lower slowly. 15 reps x 3 sets.",
                 coach: .panda),
        Activity(id: UUID(), name: "Chair Squat",
                 duration: 180,
                 description: "Stand from your chair, lower slowly back down, hover for 2 sec, stand again. x10.",
                 coach: .panda),
        Activity(id: UUID(), name: "Torso Rotation",
                 duration: 180,
                 description: "Stand, hands on hips, rotate your upper body left and right. 20 reps. Feel the bamboo life.",
                 coach: .panda),
        Activity(id: UUID(), name: "Full Body Shake-Out",
                 duration: 180,
                 description: "Literally shake your arms, legs, and body loose for 3 minutes. Looks weird. Feels amazing.",
                 coach: .panda)
    ]

    static let squirrelActivities: [Activity] = [
        Activity(id: UUID(), name: "The 5-Minute Burn",
                 duration: 300,
                 description: "1 min jumping jacks → 1 min high knees → 30 sec rest → repeat. GO GO GO.",
                 coach: .squirrel),
        Activity(id: UUID(), name: "Micro HIIT",
                 duration: 300,
                 description: "20 sec max effort (any move) → 10 sec rest → repeat 8 rounds. Tabata style. LET'S GO.",
                 coach: .squirrel),
        Activity(id: UUID(), name: "Desk Warrior Flow",
                 duration: 360,
                 description: "Lunge, plank hold 30 sec, 10 mountain climbers, repeat twice. Warrior mode unlocked.",
                 coach: .squirrel),
        Activity(id: UUID(), name: "Staircase Sprint",
                 duration: 240,
                 description: "Find stairs. Go up and down 4 times as fast as safely possible. No stairs? Step-ups on a chair.",
                 coach: .squirrel),
        Activity(id: UUID(), name: "Core Blast Circuit",
                 duration: 360,
                 description: "Plank 30 sec → side plank 20 sec each → 15 bicycle crunches → dead bug 10 reps. DONE.",
                 coach: .squirrel),
        Activity(id: UUID(), name: "Quick Squat Blast",
                 duration: 300,
                 description: "20 fast squats → 10 jump squats → 10 split jumps → rest 30 sec → repeat.",
                 coach: .squirrel),
        Activity(id: UUID(), name: "Desk Dip Set",
                 duration: 240,
                 description: "Hands on desk edge, lower body until elbows at 90°, push up. 3 sets of 12. Arms: activated.",
                 coach: .squirrel),
        Activity(id: UUID(), name: "Speed Stretch",
                 duration: 240,
                 description: "Dynamic, fast stretching — leg swings, arm swings, hip circles. Not yoga. Movement.",
                 coach: .squirrel),
        Activity(id: UUID(), name: "Fast March Sequence",
                 duration: 300,
                 description: "March in place fast, bring knees high, pump arms. 45 sec on, 15 sec rest, x4 rounds.",
                 coach: .squirrel),
        Activity(id: UUID(), name: "Nut Hunt Challenge",
                 duration: 300,
                 description: "Randomized! Each 30 sec the coach calls a new move. Squats! Push-ups! Hops! Never stop!",
                 coach: .squirrel)
    ]

    static func activities(for coach: Coach) -> [Activity] {
        switch coach {
        case .koala:    return koalaActivities
        case .panda:    return pandaActivities
        case .squirrel: return squirrelActivities
        }
    }
}
