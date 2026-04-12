//
//  ChallangeView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI

struct ChallengeView: View {
    let friend: FriendModel
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var showConfirmation = false
    @State private var challengeSent = false

    var user: User? { appState.currentUser }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // MARK: - VS Card
                HStack(spacing: 0) {
                    // Your side
                    VStack(spacing: 10) {
                        CoachAvatarView(
                            coach: user?.assignedCoach ?? .koala,
                            size: 70
                        )
                        Text("You")
                            .font(.system(size: 16, weight: .black, design: .rounded))
                        Text("\(user?.weeklyMinutes ?? 0) min")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)

                    // VS
                    Text("VS")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "#E53935"))

                    // Friend's side
                    VStack(spacing: 10) {
                        CoachAvatarView(coach: friend.coach, size: 70)
                        Text(friend.name.components(separatedBy: " ").first ?? friend.name)
                            .font(.system(size: 16, weight: .black, design: .rounded))
                        Text("\(friend.weeklyMinutes) min")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(24)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 3)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 24)

                // MARK: - Weekly Challenge card
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.yellow)
                        Text("Weekly Challenge")
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Spacer()
                        Text("3 days left")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Text("Compete to see who can accumulate more movement minutes from Monday to Sunday. Winner gets bragging rights!")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)

                    // Progress bar
                    VStack(spacing: 6) {
                        HStack {
                            Text("Your progress")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                            Text("\(user?.weeklyMinutes ?? 0) min")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 8)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white)
                                    .frame(
                                        width: geo.size.width * challengeProgress,
                                        height: 8
                                    )
                            }
                        }
                        .frame(height: 8)
                    }
                }
                .padding(20)
                .background(Color(hex: "#E53935"))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

                // MARK: - Rules
                VStack(alignment: .leading, spacing: 12) {
                    Text("How it works")
                        .font(.system(size: 18, weight: .bold, design: .rounded))

                    RuleRow(
                        icon: "calendar",
                        iconColor: .blue,
                        title: "Monday to Sunday",
                        subtitle: "Challenge runs for the full week"
                    )
                    RuleRow(
                        icon: "bolt.fill",
                        iconColor: .orange,
                        title: "Movement minutes count",
                        subtitle: "Every activity you complete adds to your total"
                    )
                    RuleRow(
                        icon: "trophy.fill",
                        iconColor: .yellow,
                        title: "Winner gets bragging rights",
                        subtitle: "Most minutes by Sunday wins the week"
                    )
                    RuleRow(
                        icon: "arrow.clockwise",
                        iconColor: .green,
                        title: "Resets every Monday",
                        subtitle: "New week, new chance to win"
                    )
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Challenge \(friend.name.components(separatedBy: " ").first ?? "")")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showConfirmation = true
                } label: {
                    Text("Challenge")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color(hex: "#E53935"))
                        .clipShape(Capsule())
                }
            }
        }
        .alert("Send Challenge?", isPresented: $showConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Send") {
                challengeSent = true
            }
        } message: {
            Text("Challenge \(friend.name) to see who can move more this week?")
        }
        .sheet(isPresented: $challengeSent) {
            ChallengeSentView(friend: friend) {
                challengeSent = false
                dismiss()
            }
        }
    }

    var challengeProgress: Double {
        let target = Double(max(friend.weeklyMinutes, 1))
        return min(Double(user?.weeklyMinutes ?? 0) / target, 1.0)
    }
}

// MARK: - Challenge Sent confirmation sheet
struct ChallengeSentView: View {
    let friend: FriendModel
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color(hex: "#E53935").opacity(0.12))
                    .frame(width: 100, height: 100)
                Image(systemName: "trophy.fill")
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundColor(Color(hex: "#E53935"))
            }

            VStack(spacing: 8) {
                Text("Challenge Sent!")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.black)

                Text("You've challenged \(friend.name)")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)

                Text("May the best mover win!")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "#E53935"))
            }

            Spacer()

            Button(action: onDismiss) {
                Text("Got It")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(hex: "#E53935"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
        .background(Color.white)
    }
}

// MARK: - Rule Row
struct RuleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
            }
        }
    }
}
