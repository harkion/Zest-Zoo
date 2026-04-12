//
//  FriendsView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI

struct FriendsView: View {
    @Environment(AppState.self) private var appState

    // Sample data — will be replaced with real data later
    let friends: [FriendModel] = [
        FriendModel(name: "Sarah Johnson", handle: "@sarahfit",
                    coach: .squirrel, streak: 12, weeklyMinutes: 156, isOnline: true),
        FriendModel(name: "Marcus Lee", handle: "@marcusmoves",
                    coach: .panda, streak: 25, weeklyMinutes: 189, isOnline: true),
        FriendModel(name: "Emma Davis", handle: "@emmazen",
                    coach: .koala, streak: 8, weeklyMinutes: 98, isOnline: false),
        FriendModel(name: "Jake Wilson", handle: "@jakeactive",
                    coach: .squirrel, streak: 19, weeklyMinutes: 167, isOnline: true)
    ]

    let recentActivity: [ActivityFeedItem] = [
        ActivityFeedItem(name: "Marcus Lee", action: "completed a 5-minute burst 🎉", time: "12 min ago"),
        ActivityFeedItem(name: "Sarah Johnson", action: "reached a 12-day streak 🔥", time: "1 hour ago"),
        ActivityFeedItem(name: "Jake Wilson", action: "earned Level 14 ⭐️", time: "3 hours ago")
    ]

    @State private var selectedTab = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Tab toggle
                HStack(spacing: 0) {
                    TabToggleButton(
                        title: "My Friends",
                        icon: "person.2.fill",
                        isSelected: selectedTab == 0
                    ) { selectedTab = 0 }

                    TabToggleButton(
                        title: "Leaderboard",
                        icon: "trophy.fill",
                        isSelected: selectedTab == 1
                    ) { selectedTab = 1 }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 20)

                if selectedTab == 0 {
                    friendsList
                } else {
                    leaderboardView
                }
            }
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // add friend action
                } label: {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.blue)
                }
            }
        }
    }

    // MARK: - Friends List
    var friendsList: some View {
        VStack(spacing: 0) {
            // Friends cards
            VStack(spacing: 1) {
                ForEach(friends) { friend in
                    FriendRow(friend: friend)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 20)

            // Recent Activity
            VStack(alignment: .leading, spacing: 12) {
                Text("Recent Activity")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .padding(.horizontal, 20)

                VStack(spacing: 1) {
                    ForEach(recentActivity) { item in
                        ActivityFeedRow(item: item)
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20)
            }
            .padding(.top, 28)
            .padding(.bottom, 32)
        }
    }

    // MARK: - Leaderboard
    var leaderboardView: some View {
        VStack(spacing: 16) {
            // Weekly challenge card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Weekly Challenge")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    Text("3 days left")
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }

                Text("Compete to see who can accumulate more movement minutes Monday to Sunday. Winner gets bragging rights! 🏆")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))

                ProgressView(value: 0.35)
                    .tint(.white)
            }
            .padding(20)
            .background(Color(hex: "#E53935"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 20)

            // Rankings
            VStack(spacing: 1) {
                ForEach(Array(friends.sorted { $0.weeklyMinutes > $1.weeklyMinutes }.enumerated()),
                        id: \.offset) { rank, friend in
                    LeaderboardRow(rank: rank + 1, friend: friend)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .padding(.top, 8)
    }
}

// MARK: - Supporting Models
struct FriendModel: Identifiable {
    let id = UUID()
    let name: String
    let handle: String
    let coach: Coach
    let streak: Int
    let weeklyMinutes: Int
    let isOnline: Bool
}

struct ActivityFeedItem: Identifiable {
    let id = UUID()
    let name: String
    let action: String
    let time: String
}

// MARK: - Supporting Views
struct FriendRow: View {
    let friend: FriendModel

    var body: some View {
        HStack(spacing: 14) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(friend.coach.primaryColor.opacity(0.2))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(friend.coach.emoji)
                            .font(.system(size: 22))
                    )
                if friend.isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(friend.name)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.black)
                Text(friend.handle)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                    Text("\(friend.streak)")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                }
                Text("\(friend.weeklyMinutes) min")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

struct ActivityFeedRow: View {
    let item: ActivityFeedItem

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.orange.opacity(0.15))
                .frame(width: 40, height: 40)
                .overlay(
                    Text("👤")
                        .font(.system(size: 18))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text("\(item.name) \(item.action)")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                Text(item.time)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct LeaderboardRow: View {
    let rank: Int
    let friend: FriendModel

    var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return Color(hex: "#C0C0C0")
        case 3: return Color(hex: "#CD7F32")
        default: return .gray.opacity(0.3)
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(rankColor.opacity(rank <= 3 ? 1 : 0.4))
                    .frame(width: 32, height: 32)
                Text("\(rank)")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(rank <= 3 ? .white : .gray)
            }

            Circle()
                .fill(friend.coach.primaryColor.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(Text(friend.coach.emoji).font(.system(size: 20)))

            VStack(alignment: .leading, spacing: 2) {
                Text(friend.name)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                Text(friend.handle)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
            }

            Spacer()

            Text("\(friend.weeklyMinutes) min")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct TabToggleButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .foregroundColor(isSelected ? .white : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? Color.blue : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(3)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
    }
}
