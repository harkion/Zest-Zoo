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
                        CoachAvatarView(coach: user?.assignedCoach ?? .koala, size: 90)
                    }

                    VStack(spacing: 4) {
                        Text(user?.name.isEmpty == false ? user!.name : " Zoo User")
                            .font(.system(size: 22, weight: .black, design: .rounded))
                            .foregroundColor(.black)
                        Text("Member since \(joinDateText)")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                    }
                        
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
                    Image(user?.assignedCoach.currencyImageName ?? "leaf_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
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
                        AchievementBadge(
                            systemIcon: "shoe.fill",
                            name: "First Steps",
                            color: .blue,
                            earned: (user?.totalActivitiesCompleted ?? 0) >= 1
                        )
                        AchievementBadge(
                            systemIcon: "flame.fill",
                            name: "Week Warrior",
                            color: .orange,
                            earned: (user?.currentStreak ?? 0) >= 7
                        )
                        AchievementBadge(
                            systemIcon: "bolt.fill",
                            name: "Speed Demon",
                            color: .yellow,
                            earned: (user?.totalActivitiesCompleted ?? 0) >= 10
                        )
                        AchievementBadge(
                            systemIcon: "trophy.fill",
                            name: "Century Club",
                            color: .purple,
                            earned: (user?.totalMinutes ?? 0) >= 100
                        )
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
    let systemIcon: String
    let name: String
    let color: Color
    let earned: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(earned
                          ? color.opacity(0.15)
                          : Color.gray.opacity(0.1))
                    .frame(width: 52, height: 52)

                Image(systemName: earned ? systemIcon : "lock.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(earned ? color : .gray.opacity(0.4))
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
