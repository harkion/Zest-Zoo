//
//  HomeView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context
    @State private var viewModel: HomeViewModel?
    @State private var selectedActivity: Activity?
    @State private var showCompletion = false
    @State private var showCoachTransition = false
    @State private var lastCompletedActivity: Activity?

    var body: some View {
        Group {
            if let vm = viewModel {
                ScrollView {
                    VStack(spacing: 0) {
                        headerSection(vm)
                        bannerSection(vm)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        dailyStatsRow(vm)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        coachCard(vm)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        NavigationLink(destination: WeeklyProgressView()) {
                            weeklyProgressCard(vm)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        quickActionsRow(vm)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            .padding(.bottom, 32)
                    }
                }
                .background(Color(hex: "#F5F5F7"))

               
                .sheet(item: $selectedActivity) { activity in
                    ActivityView(
                        activity: activity,
                        coach: vm.user.assignedCoach
                    ) {
                        lastCompletedActivity = activity
                        selectedActivity = nil
                        vm.completeSession(activity: activity, context: context)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showCompletion = true
                        }
                    }
                }

                .fullScreenCover(isPresented: $showCompletion) {
                    if let activity = lastCompletedActivity {
                        CompletionView(
                            activity: activity,
                            coach: vm.user.assignedCoach,
                            currencyEarned: 15
                        ) {
                            showCompletion = false
                            if vm.pendingTransition != nil {
                                showCoachTransition = true
                            }
                        }
                    }
                }

                .fullScreenCover(isPresented: $showCoachTransition) {
                    if let transition = viewModel?.pendingTransition {
                        CoachTransitionView(transition: transition) {
                            showCoachTransition = false
                            viewModel?.applyPendingTransition(context: context)
                        }
                    }
                }

            } else {
                ProgressView()
            }
        }
        .onAppear {
            if viewModel == nil, let user = appState.currentUser {
                viewModel = HomeViewModel(user: user)
            }
        }
    }

    // MARK: - Header
    @ViewBuilder
    private func headerSection(_ vm: HomeViewModel) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(vm.greetingText)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.black)
                Text(vm.dateText)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
            }
            Spacer()
            Button {
                // notifications — will wire later
            } label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)

                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Banner
    @ViewBuilder
    private func bannerSection(_ vm: HomeViewModel) -> some View {
        if let banner = vm.motivationalBanner {
            HStack(spacing: 12) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Text(banner)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#4A90D9"), Color(hex: "#357ABD")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Daily Stats Row
    @ViewBuilder
    private func dailyStatsRow(_ vm: HomeViewModel) -> some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "flame.fill",
                iconColor: .orange,
                value: "\(vm.user.currentStreak)",
                label: "day streak"
            )
            CurrencyStatCard(
                coach: vm.user.assignedCoach,
                value: "\(vm.user.currencyBalance)"
            )
        }
    }

    // MARK: - Coach Card
    @ViewBuilder
    private func coachCard(_ vm: HomeViewModel) -> some View {
        VStack(spacing: 16) {
            CoachAvatarView(coach: vm.user.assignedCoach, size: 110)

            VStack(spacing: 6) {
                Text(vm.user.assignedCoach.displayName)
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(.black)
                Text(vm.user.assignedCoach.tagline)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
            }

            HStack(spacing: 6) {
                ForEach(0..<vm.user.dailySessionGoal, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(i < vm.user.dailySessionsCompleted
                              ? vm.user.assignedCoach.primaryColor
                              : Color.gray.opacity(0.2))
                        .frame(height: 5)
                        .animation(
                            .spring(duration: 0.4),
                            value: vm.user.dailySessionsCompleted
                        )
                }
            }
            .padding(.horizontal, 8)

            Text("\(vm.dailyProgressText) sessions today")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.gray)


            Button {
                selectedActivity = vm.todaysActivity
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 16, weight: .bold))
                    Text("Start Movement")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(vm.user.assignedCoach.primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(20)
        .background(vm.user.assignedCoach.secondaryColor)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(
            color: vm.user.assignedCoach.primaryColor.opacity(0.15),
            radius: 12, x: 0, y: 4
        )
    }

    // MARK: - Weekly Progress
    @ViewBuilder
    private func weeklyProgressCard(_ vm: HomeViewModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                    .font(.system(size: 16, weight: .medium))
                Text("Weekly Progress")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                Spacer()
                Text("\(Int(vm.weeklyProgressPercent * 100))%")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.green)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 10)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.green)
                        .frame(
                            width: geo.size.width * vm.weeklyProgressPercent,
                            height: 10
                        )
                        .animation(
                            .spring(duration: 0.6),
                            value: vm.weeklyProgressPercent
                        )
                }
            }
            .frame(height: 10)

            HStack {
                Text("\(vm.user.weeklyMinutes) / \(vm.user.weeklyGoalMinutes) minutes")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                Spacer()
                if vm.minutesToGoal > 0 {
                    Text("\(vm.minutesToGoal) min to goal")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                } else {
                    Text("Goal reached!")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                }
            }
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 3)
    }

    // MARK: - Quick Actions
    @ViewBuilder
    private func quickActionsRow(_ vm: HomeViewModel) -> some View {
        HStack(spacing: 12) {
            QuickActionCard(
                icon: "gift.fill",
                iconColor: .orange,
                label: "Daily Reward",
                destination: AnyView(DailyRewardView())
            )
            QuickActionCard(
                icon: "trophy.fill",
                iconColor: .purple,
                label: "Achievements",
                destination: AnyView(AchievementsView())
            )
        }
    }
}

// MARK: - Currency Stat Card
struct CurrencyStatCard: View {
    let coach: Coach
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            CurrencyIconView(coach: coach, size: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundColor(.black)
                Text(coach.currencyName.lowercased())
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(iconColor)
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundColor(.black)
                Text(label)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Quick Action Card
struct QuickActionCard: View {
    let icon: String
    let iconColor: Color
    let label: String
    let destination: AnyView

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                Text(label)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}
