//
//  NotificationsView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 13/04/2026.
//

import SwiftUI
import UserNotifications

struct NotificationsView: View {
    @Environment(AppState.self) private var appState

    @State private var permissionGranted = false
    @State private var isLoading = true

    @State private var morningEnabled = true
    @State private var morningTime = Date.from(hour: 9, minute: 0)

    @State private var afternoonEnabled = true
    @State private var afternoonTime = Date.from(hour: 14, minute: 0)

    @State private var eveningEnabled = false
    @State private var eveningTime = Date.from(hour: 18, minute: 0)

    @State private var inactivityNudge = true
    @State private var weeklySummary = true

    @State private var showPermissionAlert = false
    @State private var saved = false

    var coach: Coach {
        appState.currentUser?.assignedCoach ?? .koala
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // MARK: - Permission status card
                permissionCard
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                if permissionGranted {

                    // MARK: - Scheduled nudges
                    VStack(alignment: .leading, spacing: 8) {
                        sectionHeader("Scheduled Nudges")

                        VStack(spacing: 0) {
                            NudgeTimeRow(
                                icon: "sunrise.fill",
                                iconColor: .orange,
                                title: "Morning",
                                subtitle: "Start your day with movement",
                                isEnabled: $morningEnabled,
                                time: $morningTime
                            )
                            Divider().padding(.leading, 56)
                            NudgeTimeRow(
                                icon: "sun.max.fill",
                                iconColor: .yellow,
                                title: "Afternoon",
                                subtitle: "Beat the afternoon slump",
                                isEnabled: $afternoonEnabled,
                                time: $afternoonTime
                            )
                            Divider().padding(.leading, 56)
                            NudgeTimeRow(
                                icon: "moon.fill",
                                iconColor: .indigo,
                                title: "Evening",
                                subtitle: "Wind down with gentle movement",
                                isEnabled: $eveningEnabled,
                                time: $eveningTime
                            )
                        }
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
                    }
                    .padding(.horizontal, 20)

                    // MARK: - Smart nudges
                    VStack(alignment: .leading, spacing: 8) {
                        sectionHeader("Smart Nudges")

                        VStack(spacing: 0) {
                            SmartNudgeRow(
                                icon: "figure.seated.seatbelt",
                                iconColor: coach.primaryColor,
                                title: "Inactivity Detection",
                                subtitle: "\(coach.nickname) nudges you after 45 min of sitting",
                                isEnabled: $inactivityNudge
                            )
                            Divider().padding(.leading, 56)
                            SmartNudgeRow(
                                icon: "calendar.badge.clock",
                                iconColor: .purple,
                                title: "Weekly Summary",
                                subtitle: "Your weekly recap every Sunday evening",
                                isEnabled: $weeklySummary
                            )
                        }
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
                    }
                    .padding(.horizontal, 20)

                    // MARK: - Coach preview
                    VStack(alignment: .leading, spacing: 8) {
                        sectionHeader("Nudge Preview")

                        VStack(spacing: 12) {
                            ForEach(coach.nudgeMessages.prefix(2), id: \.self) { message in
                                NudgePreviewBubble(
                                    coach: coach,
                                    message: message
                                )
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
                    }
                    .padding(.horizontal, 20)

                    // MARK: - Save button
                    Button {
                        saveSettings()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: saved ? "checkmark.circle.fill" : "bell.badge.fill")
                                .font(.system(size: 18, weight: .semibold))
                            Text(saved ? "Saved!" : "Save Notification Settings")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(saved ? Color.green : coach.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(
                            color: (saved ? Color.green : coach.primaryColor).opacity(0.3),
                            radius: 10, x: 0, y: 4
                        )
                    }
                    .padding(.horizontal, 20)
                    .animation(.spring(duration: 0.3), value: saved)

                } else if !isLoading {
                    // Not granted — show explanation
                    notGrantedView
                        .padding(.horizontal, 20)
                }

                Spacer().frame(height: 40)
            }
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await checkPermission()
        }
        .alert("Open Settings", isPresented: $showPermissionAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("Please enable notifications for Zest Zoo in your iPhone Settings to receive nudges from \(coach.nickname).")
        }
    }

    // MARK: - Permission card
    var permissionCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(permissionGranted
                          ? Color.green.opacity(0.12)
                          : Color.orange.opacity(0.12))
                    .frame(width: 52, height: 52)
                Image(systemName: permissionGranted
                      ? "bell.badge.fill"
                      : "bell.slash.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(permissionGranted ? .green : .orange)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(permissionGranted
                     ? "Notifications Enabled"
                     : "Notifications Disabled")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                Text(permissionGranted
                     ? "\(coach.nickname) can send you nudges"
                     : "Enable to receive nudges from \(coach.nickname)")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
            }

            Spacer()

            if !permissionGranted {
                Button {
                    Task { await requestPermission() }
                } label: {
                    Text("Enable")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(coach.primaryColor)
                        .clipShape(Capsule())
                }
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.green)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    // MARK: - Not granted view
    var notGrantedView: some View {
        VStack(spacing: 20) {
            Image(coach.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .opacity(0.6)

            VStack(spacing: 8) {
                Text("Notifications are off")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(.black)

                Text("\(coach.nickname) can't reach you without notifications. Enable them to get gentle movement nudges throughout your day.")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }

            Button {
                showPermissionAlert = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "gear")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Open iPhone Settings")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(coach.primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(24)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    // MARK: - Section header helper
    func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundColor(.gray)
            .padding(.leading, 4)
    }

    // MARK: - Logic
    func checkPermission() async {
        let settings = await UNUserNotificationCenter.current()
            .notificationSettings()
        await MainActor.run {
            permissionGranted = settings.authorizationStatus == .authorized
            isLoading = false
        }
    }

    func requestPermission() async {
        let granted = await NotificationService.shared.requestPermission()
        await MainActor.run {
            permissionGranted = granted
            if granted {
                scheduleAll()
            } else {
                showPermissionAlert = true
            }
        }
    }

    func saveSettings() {
        var times: [NudgeTime] = []

        if morningEnabled {
            times.append(NudgeTime(
                id: "morning",
                hour: Calendar.current.component(.hour, from: morningTime),
                minute: Calendar.current.component(.minute, from: morningTime),
                isEnabled: true,
                label: "Morning"
            ))
        }
        if afternoonEnabled {
            times.append(NudgeTime(
                id: "afternoon",
                hour: Calendar.current.component(.hour, from: afternoonTime),
                minute: Calendar.current.component(.minute, from: afternoonTime),
                isEnabled: true,
                label: "Afternoon"
            ))
        }
        if eveningEnabled {
            times.append(NudgeTime(
                id: "evening",
                hour: Calendar.current.component(.hour, from: eveningTime),
                minute: Calendar.current.component(.minute, from: eveningTime),
                isEnabled: true,
                label: "Evening"
            ))
        }

        NotificationService.shared.scheduleDailyNudges(for: coach, times: times)

        if weeklySummary {
            NotificationService.shared.scheduleWeeklySummary(for: coach)
        }

        withAnimation(.spring(duration: 0.3)) { saved = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { saved = false }
        }
    }

    func scheduleAll() {
        saveSettings()
    }
}

// MARK: - Nudge Time Row
struct NudgeTimeRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    @Binding var isEnabled: Bool
    @Binding var time: Date

    var body: some View {
        VStack(spacing: 0) {
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
                Toggle("", isOn: $isEnabled)
                    .labelsHidden()
                    .tint(iconColor)
            }
            .padding(16)

            // Time picker — only shows when enabled
            if isEnabled {
                HStack {
                    Spacer()
                    DatePicker(
                        "",
                        selection: $time,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(iconColor)
                    .padding(.trailing, 16)
                    .padding(.bottom, 12)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.spring(duration: 0.3), value: isEnabled)
    }
}

// MARK: - Smart Nudge Row
struct SmartNudgeRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    @Binding var isEnabled: Bool

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
            Toggle("", isOn: $isEnabled)
                .labelsHidden()
                .tint(iconColor)
        }
        .padding(16)
    }
}

// MARK: - Nudge Preview Bubble
struct NudgePreviewBubble: View {
    let coach: Coach
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(coach.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(coach.displayName)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(coach.primaryColor)

                Text(message)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .background(coach.secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()
        }
    }
}

// MARK: - Date helper
extension Date {
    static func from(hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components) ?? Date()
    }
}
