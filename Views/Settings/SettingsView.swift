//
//  SettingsView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context

    @State private var notificationsEnabled = true
    @State private var morningNudge = true
    @State private var afternoonNudge = true
    @State private var eveningNudge = false
    @State private var showResetAlert = false

    var coach: Coach {
        appState.currentUser?.assignedCoach ?? .koala
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // MARK: - App version card
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(coach.primaryColor)
                            .frame(width: 52, height: 52)
                        Image(coach.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Zest Zoo")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                        Text("Version 1.0.0")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 6)
                .padding(.horizontal, 20)
                .padding(.top, 8)

                // MARK: - Notifications
                SettingsSection(title: "Notifications") {
                    SettingsToggleRow(
                        icon: "bell.fill",
                        iconColor: .blue,
                        title: "Enable Nudges",
                        subtitle: "Let \(coach.nickname) remind you to move",
                        isOn: $notificationsEnabled
                    )
                    Divider().padding(.leading, 56)
                    SettingsToggleRow(
                        icon: "sunrise.fill",
                        iconColor: .orange,
                        title: "Morning Nudge",
                        subtitle: "Around 9:00 AM",
                        isOn: $morningNudge
                    )
                    Divider().padding(.leading, 56)
                    SettingsToggleRow(
                        icon: "sun.max.fill",
                        iconColor: .yellow,
                        title: "Afternoon Nudge",
                        subtitle: "Around 2:00 PM",
                        isOn: $afternoonNudge
                    )
                    Divider().padding(.leading, 56)
                    SettingsToggleRow(
                        icon: "moon.fill",
                        iconColor: .indigo,
                        title: "Evening Nudge",
                        subtitle: "Around 6:00 PM",
                        isOn: $eveningNudge
                    )
                }
                .padding(.horizontal, 20)

                // MARK: - About
                SettingsSection(title: "About") {
                    NavigationLink(destination: AboutView()) {
                        SettingsLinkRow(
                            icon: "info.circle.fill",
                            iconColor: .blue,
                            title: "About Zest Zoo"
                        )
                    }
                    .buttonStyle(.plain)

                    Divider().padding(.leading, 56)

                    NavigationLink(destination: HelpCenterView()) {
                        SettingsLinkRow(
                            icon: "questionmark.circle.fill",
                            iconColor: .green,
                            title: "Help Center"
                        )
                    }
                    .buttonStyle(.plain)

                    Divider().padding(.leading, 56)

                    SettingsLinkRow(
                        icon: "lock.shield.fill",
                        iconColor: .gray,
                        title: "Privacy Policy"
                    )

                    Divider().padding(.leading, 56)

                    SettingsLinkRow(
                        icon: "doc.text.fill",
                        iconColor: .gray,
                        title: "Terms of Service"
                    )
                }
                .padding(.horizontal, 20)

                // MARK: - Account / Danger zone
                SettingsSection(title: "Account") {
                    Button {
                        showResetAlert = true
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.12))
                                    .frame(width: 32, height: 32)
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.red)
                            }
                            Text("Reset")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .padding(16)
                    }
                }
                .padding(.horizontal, 20)

                // MARK: - Footer
                HStack(spacing: 4) {
                    Text("Made with")
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("for a healthier, happier you.")
                }
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundColor(.gray)
                .padding(.bottom, 40)
            }
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .alert("Reset Everything?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset & Restart", role: .destructive) {
                resetProgress()
            }
        } message: {
            Text("This will delete all your progress, streaks, currency, and coach assignment. You'll go back to the quiz to start fresh. This cannot be undone.")
        }
        
    }

    // MARK: - Reset — inside struct, after body
    private func resetProgress() {
        // clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")

        // delete all SwiftData records
        do {
            let activityDescriptor = FetchDescriptor<ActivityRecord>()
            let activities = try context.fetch(activityDescriptor)
            activities.forEach { context.delete($0) }

            let userDescriptor = FetchDescriptor<User>()
            let users = try context.fetch(userDescriptor)
            users.forEach { context.delete($0) }

            try context.save()
        } catch {
            print("Reset error: \(error)")
        }

        // send back to onboarding
        appState.currentUser = nil
        appState.appPhase = .onboarding
    }
}

// MARK: - Settings Section
struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.gray)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                content
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }
}

// MARK: - Settings Toggle Row
struct SettingsToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.black)
                Text(subtitle)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(iconColor)
        }
        .padding(16)
    }
}

// MARK: - Settings Link Row
struct SettingsLinkRow: View {
    let icon: String
    let iconColor: Color
    let title: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(16)
    }
}
