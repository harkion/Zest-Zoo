//
//  DailyRewardView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI

struct DailyRewardView: View {
    @Environment(AppState.self) private var appState
    @State private var claimed = false
    @State private var showCelebration = false

    let weekRewards = [5, 10, 15, 20, 30, 40, 100]

    var currentDay: Int {
        let streak = appState.currentUser?.currentStreak ?? 0
        return max(1, min(streak + 1, 7))
    }

    var todayReward: Int {
        let index = max(0, min(currentDay - 1, weekRewards.count - 1))
        return weekRewards[index]
    }

    var coach: Coach {
        appState.currentUser?.assignedCoach ?? .koala
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // MARK: - Top reward card
                
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 70, height: 70)
                        Image(systemName: "gift.fill")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(.white)
                    }

                    Text("Day \(currentDay) Streak")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(.white)

                    Text("Come back daily to claim rewards")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))

                    HStack {
                        Text("Today's reward")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                        Spacer()
                        HStack(spacing: 6) {
                            Image(coach.currencyImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                            Text("\(todayReward)")
                                .font(.system(size: 20, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(20)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "#FFB300"), Color(hex: "#FF8F00")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 24)

                // MARK: - This Week label
                
                Text("This Week")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)

                // MARK: - Day cells
                
                HStack(spacing: 6) {
                    ForEach(0..<7, id: \.self) { i in
                        DayRewardCell(
                            day: i + 1,
                            reward: weekRewards[i],
                            coach: coach,
                            state: dayState(for: i + 1),
                            isSpecial: i == 6
                        )
                    }
                }
                .padding(.horizontal, 16)

                // MARK: - Info cards
                
                VStack(spacing: 12) {
                    RewardInfoCard(
                        icon: "sparkles",
                        iconColor: .yellow,
                        title: "Consistency Bonus",
                        subtitle: "Complete 7 days in a row to earn a special bonus reward"
                    )
                    RewardInfoCard(
                        icon: "alarm.fill",
                        iconColor: .red,
                        title: "Don't Break the Chain",
                        subtitle: "Missing a day will reset your streak back to day 1"
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)

                // MARK: - Claim button
                
                Button {
                    guard !claimed else { return }
                    withAnimation(.spring(duration: 0.4)) {
                        claimed = true
                        showCelebration = true
                    }
                    if let user = appState.currentUser {
                        user.currencyBalance += todayReward
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: claimed ? "checkmark.circle.fill" : "gift.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        Text(claimed ? "Claimed!" : "Claim Today's Reward")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(claimed ? Color.gray : Color(hex: "#FFB300"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 16)
                .disabled(claimed)
                .animation(.easeInOut(duration: 0.3), value: claimed)

                // MARK: - Celebration
                
                if showCelebration {
                    VStack(spacing: 8) {
                        Image(coach.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)

                        Text(celebrationMessage)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(coach.primaryColor)
                            .multilineTextAlignment(.center)
                    }
                    .padding(20)
                    .background(coach.secondaryColor)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 20)
                    .transition(.scale.combined(with: .opacity))
                }

                Spacer().frame(height: 40)
            }
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Daily Rewards")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Helpers

    func dayState(for day: Int) -> DayRewardCell.DayState {
        let streak = appState.currentUser?.currentStreak ?? 0
        if day < currentDay && streak > 0 { return .completed }
        if day == currentDay               { return .today }
        return .upcoming
    }

    var celebrationMessage: String {
        switch coach {
        case .koala:
            return "You showed up. That's everything. \(todayReward) leafs earned… now rest."
        case .panda:
            return "Bamboo collected! \(todayReward) bamboo shoots added. Keep the streak alive!"
        case .squirrel:
            return "\(todayReward) acorns SECURED! Come back tomorrow. Don't stop now!"
        }
    }
}

// MARK: - Day Reward Cell

struct DayRewardCell: View {
    let day: Int
    let reward: Int
    let coach: Coach
    let state: DayState
    let isSpecial: Bool

    enum DayState {
        case completed
        case today
        case upcoming
    }

    var body: some View {
        VStack(spacing: 6) {
            Text("Day\n\(day)")
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(labelColor)
                .lineLimit(2)

            if isSpecial && state == .upcoming {
                Image(systemName: "gift.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.orange)
            } else if state == .completed {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            } else {
                Image(coach.currencyImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
            }

            Text("\(reward)")
                .font(.system(size: 10, weight: .black, design: .rounded))
                .foregroundColor(labelColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var labelColor: Color {
        switch state {
        case .completed: return .white
        case .today:     return .black
        case .upcoming:  return .gray
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch state {
        case .completed:
            Color.green
        case .today:
            Color.white
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 2)
                )
        case .upcoming:
            Color.white.opacity(0.6)
        }
    }
}

// MARK: - Reward Info Card

struct RewardInfoCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}
