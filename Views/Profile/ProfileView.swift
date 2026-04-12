//
//  ProfileView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState

    var user: User? { appState.currentUser }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Profile header
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(user?.assignedCoach.primaryColor ?? .gray)
                            .frame(width: 90, height: 90)
                        Text(user?.assignedCoach.emoji ?? "🐨")
                            .font(.system(size: 50))
                    }

                    VStack(spacing: 4) {
                        Text(user?.name.isEmpty == false ? user!.name : "Zest Zoo User")
                            .font(.system(size: 22, weight: .black, design: .rounded))
                            .foregroundColor(.black)
                        Text("Member since \(joinDateText)")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                    }

                    // Coach badge
                    HStack(spacing: 8) {
                        Text(user?.assignedCoach.emoji ?? "🐨")
                            .font(.system(size: 16))
                        Text(user?.assignedCoach.displayName ?? "Coach Koala")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(user?.assignedCoach.primaryColor ?? .gray)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background((user?.assignedCoach.primaryColor ?? .gray).opacity(0.12))
                    .clipShape(Capsule())
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
                .background(Color.white)

                // Stats grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ProfileStatCell(
                        value: "\(user?.currentStreak ?? 0)",
                        label: "Day Streak",
                        icon: "flame.fill",
                        color: .orange
                    )
                    ProfileStatCell(
                        value: "\(user?.totalMinutes ?? 0)",
                        label: "Total Mins",
                        icon: "clock.fill",
                        color: .blue
                    )
                    ProfileStatCell(
                        value: "\(user?.totalActivitiesCompleted ?? 0)",
                        label: "Activities",
                        icon: "bolt.fill",
                        color: user?.assignedCoach.primaryColor ?? .gray
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Currency balance
                HStack(spacing: 12) {
                    Text(user?.assignedCoach.currencyEmoji ?? "🍃")
                        .font(.system(size: 28))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(user?.currencyBalance ?? 0) \(user?.assignedCoach.currencyName ?? "Leafs")")
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .foregroundColor(.black)
                        Text("Total earned")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(18)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                .padding(.top, 16)

                // Achievements preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Achievements")
                        .font(.system(size: 18, weight: .bold, design: .rounded))

                    HStack(spacing: 12) {
                        AchievementBadge(icon: "👟", name: "First Steps",
                                         earned: (user?.totalActivitiesCompleted ?? 0) >= 1)
                        AchievementBadge(icon: "🔥", name: "Week Warrior",
                                         earned: (user?.currentStreak ?? 0) >= 7)
                        AchievementBadge(icon: "⚡️", name: "Speed Demon",
                                         earned: (user?.totalActivitiesCompleted ?? 0) >= 10)
                        AchievementBadge(icon: "🏆", name: "Century Club",
                                         earned: (user?.totalMinutes ?? 0) >= 100)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
    }

    var joinDateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: user?.joinDate ?? Date())
    }
}

struct ProfileStatCell: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundColor(.black)
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

struct AchievementBadge: View {
    let icon: String
    let name: String
    let earned: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(earned ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 52, height: 52)
                Text(earned ? icon : "🔒")
                    .font(.system(size: 24))
                    .grayscale(earned ? 0 : 1)
                    .opacity(earned ? 1 : 0.4)
            }
            Text(name)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(earned ? .black : .gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}
