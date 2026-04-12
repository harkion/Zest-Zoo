//
//  AchievementsView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 12/04/2026.
//

import SwiftUI

struct AchievementsView: View {
    @Environment(AppState.self) private var appState

    var user: User? { appState.currentUser }

    var achievements: [Achievement] {
        Achievement.all(for: user)
    }

    @State private var selectedFilter: AchievementFilter = .all

    enum AchievementFilter: String, CaseIterable {
        case all = "All"
        case unlocked = "Unlocked"
        case locked = "Locked"
    }

    var filtered: [Achievement] {
        switch selectedFilter {
        case .all:      return achievements
        case .unlocked: return achievements.filter { $0.earned }
        case .locked:   return achievements.filter { !$0.earned }
        }
    }

    var earnedCount: Int { achievements.filter { $0.earned }.count }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // MARK: - Summary card
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 60, height: 60)
                        Image(systemName: "rosette")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(earnedCount)/\(achievements.count)")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text("Achievements Unlocked")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                    }

                    Spacer()
                }
                .padding(20)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "#FF9500"), Color(hex: "#FF6B00")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 4)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "#FF9500"))
                            .frame(
                                width: geo.size.width * (Double(earnedCount) / Double(max(achievements.count, 1))),
                                height: 6
                            )
                            .animation(.spring(duration: 0.6), value: earnedCount)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)

                // MARK: - Filter tabs
                HStack(spacing: 0) {
                    ForEach(AchievementFilter.allCases, id: \.self) { filter in
                        Button {
                            withAnimation(.spring(duration: 0.3)) {
                                selectedFilter = filter
                            }
                        } label: {
                            Text(filter.rawValue)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(selectedFilter == filter ? .black : .gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    selectedFilter == filter
                                        ? Color.white
                                        : Color.clear
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding(4)
                .background(Color.gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 13))
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

                // MARK: - Achievement list
                VStack(spacing: 12) {
                    ForEach(filtered) { achievement in
                        AchievementRow(achievement: achievement, coach: user?.assignedCoach ?? .koala)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Achievement Row
struct AchievementRow: View {
    let achievement: Achievement
    let coach: Coach

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(achievement.earned
                          ? achievement.color.opacity(0.15)
                          : Color.gray.opacity(0.1))
                    .frame(width: 56, height: 56)

                if achievement.earned {
                    Image(systemName: achievement.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(achievement.color)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.gray.opacity(0.4))
                }
            }

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(achievement.earned ? .black : .gray)

                Text(achievement.description)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)

                // Progress bar for unearned
                if !achievement.earned && achievement.progressMax > 1 {
                    VStack(alignment: .leading, spacing: 3) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 5)
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.blue)
                                    .frame(
                                        width: geo.size.width * min(
                                            Double(achievement.progressCurrent) / Double(achievement.progressMax),
                                            1.0
                                        ),
                                        height: 5
                                    )
                            }
                        }
                        .frame(height: 5)

                        Text("\(achievement.progressCurrent)/\(achievement.progressMax)")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 2)
                }
            }

            Spacer()

            // Earned checkmark
            if achievement.earned {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 22))
                    .foregroundColor(achievement.color)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        .opacity(achievement.earned ? 1 : 0.7)
    }
}

// MARK: - Achievement Model
struct Achievement: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let color: Color
    let earned: Bool
    let progressCurrent: Int
    let progressMax: Int

    static func all(for user: User?) -> [Achievement] {
        let activities = user?.totalActivitiesCompleted ?? 0
        let streak = user?.currentStreak ?? 0
        let minutes = user?.totalMinutes ?? 0
        let friends = 0 // placeholder until friend system is real

        return [
            Achievement(
                name: "First Steps",
                description: "Complete your first movement",
                icon: "shoe.fill",
                color: .blue,
                earned: activities >= 1,
                progressCurrent: min(activities, 1),
                progressMax: 1
            ),
            Achievement(
                name: "Week Warrior",
                description: "Move for 7 days straight",
                icon: "flame.fill",
                color: .orange,
                earned: streak >= 7,
                progressCurrent: min(streak, 7),
                progressMax: 7
            ),
            Achievement(
                name: "Speed Demon",
                description: "Complete 10 quick bursts",
                icon: "bolt.fill",
                color: .yellow,
                earned: activities >= 10,
                progressCurrent: min(activities, 10),
                progressMax: 10
            ),
            Achievement(
                name: "Century Club",
                description: "Accumulate 100 minutes of movement",
                icon: "trophy.fill",
                color: .purple,
                earned: minutes >= 100,
                progressCurrent: min(minutes, 100),
                progressMax: 100
            ),
            Achievement(
                name: "Early Bird",
                description: "Complete a movement before 8 AM",
                icon: "sunrise.fill",
                color: .orange,
                earned: false, // tracked via time check in future
                progressCurrent: 0,
                progressMax: 1
            ),
            Achievement(
                name: "Night Owl",
                description: "Complete a movement after 10 PM",
                icon: "moon.stars.fill",
                color: .indigo,
                earned: false,
                progressCurrent: 0,
                progressMax: 1
            ),
            Achievement(
                name: "Social Butterfly",
                description: "Add 5 friends",
                icon: "person.2.fill",
                color: .pink,
                earned: friends >= 5,
                progressCurrent: min(friends, 5),
                progressMax: 5
            ),
            Achievement(
                name: "Marathon Master",
                description: "Accumulate 1000 minutes of movement",
                icon: "medal.fill",
                color: .green,
                earned: minutes >= 1000,
                progressCurrent: min(minutes, 1000),
                progressMax: 1000
            ),
            Achievement(
                name: "Perfect Month",
                description: "Move every day for 30 days",
                icon: "calendar.badge.checkmark",
                color: .teal,
                earned: streak >= 30,
                progressCurrent: min(streak, 30),
                progressMax: 30
            )
        ]
    }
}
