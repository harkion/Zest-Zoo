//
//  ActivityView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI

struct ActivityView: View {
    let activity: Activity
    let coach: Coach
    let onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var secondsRemaining: Int
    @State private var isRunning = false
    @State private var isFinished = false
    @State private var showSkipAlert = false
    @State private var coachBounce = false
    @State private var pulseRing = false
    @State private var timerTask: Task<Void, Never>? = nil

    init(activity: Activity, coach: Coach, onComplete: @escaping () -> Void) {
        self.activity = activity
        self.coach = coach
        self.onComplete = onComplete
        _secondsRemaining = State(initialValue: activity.duration)
    }

    var progress: Double {
        guard activity.duration > 0 else { return 1 }
        return Double(activity.duration - secondsRemaining) / Double(activity.duration)
    }

    var timeText: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var motivationalLine: String {
        let percent = progress
        switch coach {
        case .koala:
            if !isRunning && !isFinished { return "No rush… whenever you're ready." }
            if percent < 0.3 { return "That's it… nice and easy." }
            if percent < 0.6 { return "You're doing it. Keep breathing." }
            if percent < 0.9 { return "Almost there… easy does it." }
            return "That's enough. You did beautifully."

        case .panda:
            if !isRunning && !isFinished { return "Ready when you are, bro." }
            if percent < 0.3 { return "Good start! Feel that bamboo energy." }
            if percent < 0.6 { return "Halfway! Don't stop now — trust the process." }
            if percent < 0.9 { return "So close! Give it the last push." }
            return "That's what I'm talking about! Nailed it."

        case .squirrel:
            if !isRunning && !isFinished { return "Clock's ticking. Let's MOVE." }
            if percent < 0.3 { return "GO GO GO! You've got this!" }
            if percent < 0.6 { return "Keep that energy UP! Halfway done!" }
            if percent < 0.9 { return "ALMOST THERE! Don't you dare slow down!" }
            return "DONE! That's how it's done! YES!"
        }
    }

    var body: some View {
        ZStack {
            // Background
            coach.secondaryColor.ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: - Top bar
                HStack {
                    Button {
                        if isRunning {
                            showSkipAlert = true
                        } else {
                            timerTask?.cancel()
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.gray)
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text(activity.name)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black)

                    Spacer()

                    // Duration badge
                    Text(durationBadge)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(coach.primaryColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(coach.primaryColor.opacity(0.12))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Spacer()

                // MARK: - Coach animation area
                ZStack {
                    // Pulse rings
                    Circle()
                        .stroke(
                            coach.primaryColor.opacity(0.1),
                            lineWidth: 2
                        )
                        .frame(
                            width: pulseRing ? 220 : 180,
                            height: pulseRing ? 220 : 180
                        )
                        .animation(
                            isRunning
                                ? .easeInOut(duration: 1.2)
                                    .repeatForever(autoreverses: true)
                                : .default,
                            value: pulseRing
                        )

                    Circle()
                        .stroke(
                            coach.primaryColor.opacity(0.15),
                            lineWidth: 3
                        )
                        .frame(
                            width: pulseRing ? 180 : 150,
                            height: pulseRing ? 180 : 150
                        )
                        .animation(
                            isRunning
                                ? .easeInOut(duration: 1.0)
                                    .repeatForever(autoreverses: true)
                                    .delay(0.2)
                                : .default,
                            value: pulseRing
                        )

                    // Coach avatar — bounces when running
                    ZStack {
                        Circle()
                            .fill(coach.primaryColor)
                            .frame(width: 130, height: 130)

                        // Movement illustration image
                        // Uses activity-specific image if available,
                        // falls back to coach image
                        Image(activityImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                    }
                    .offset(y: coachBounce ? -10 : 0)
                    .animation(
                        isRunning
                            ? .easeInOut(duration: 0.5)
                                .repeatForever(autoreverses: true)
                            : .spring(duration: 0.3),
                        value: coachBounce
                    )
                }
                .padding(.bottom, 24)

                // MARK: - Motivational line
                Text(motivationalLine)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 32)
                    .animation(.easeInOut(duration: 0.4), value: motivationalLine)

                // MARK: - Timer ring
                ZStack {
                    // Track
                    Circle()
                        .stroke(Color.gray.opacity(0.12), lineWidth: 16)
                        .frame(width: 160, height: 160)

                    // Progress
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            isFinished ? Color.green : coach.primaryColor,
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )
                        .frame(width: 160, height: 160)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: progress)

                    // Time display
                    VStack(spacing: 4) {
                        if isFinished {
                            Image(systemName: "checkmark")
                                .font(.system(size: 36, weight: .black))
                                .foregroundColor(.green)
                        } else {
                            Text(timeText)
                                .font(.system(
                                    size: 40,
                                    weight: .black,
                                    design: .rounded
                                ))
                                .monospacedDigit()
                                .foregroundColor(.black)

                            Text(isRunning ? "remaining" : "to go")
                                .font(.system(
                                    size: 12,
                                    weight: .medium,
                                    design: .rounded
                                ))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.bottom, 40)

                Spacer()

                // MARK: - Description
                Text(activity.description)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
                    .padding(.bottom, 32)

                // MARK: - Control buttons
                VStack(spacing: 12) {
                    // Main CTA
                    Button {
                        handleMainButton()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: mainButtonIcon)
                                .font(.system(size: 18, weight: .bold))
                            Text(mainButtonLabel)
                                .font(.system(
                                    size: 18,
                                    weight: .bold,
                                    design: .rounded
                                ))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            isFinished
                                ? Color.green
                                : coach.primaryColor
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(
                            color: (isFinished
                                    ? Color.green
                                    : coach.primaryColor).opacity(0.3),
                            radius: 10,
                            x: 0,
                            y: 4
                        )
                    }
                    .animation(.spring(duration: 0.3), value: isFinished)

                    // Skip button — only when not finished
                    if !isFinished {
                        Button {
                            showSkipAlert = true
                        } label: {
                            Text("Skip this one")
                                .font(.system(
                                    size: 14,
                                    weight: .medium,
                                    design: .rounded
                                ))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .alert("Skip this activity?", isPresented: $showSkipAlert) {
            Button("Keep Going", role: .cancel) {}
            Button("Skip", role: .destructive) {
                timerTask?.cancel()
                dismiss()
            }
        } message: {
            Text("Your progress won't be saved if you skip.")
        }
        .onDisappear {
            timerTask?.cancel()
        }
    }

    // MARK: - Helpers
    var durationBadge: String {
        let m = activity.duration / 60
        let s = activity.duration % 60
        if s == 0 { return "\(m) min" }
        return "\(m)m \(s)s"
    }

    var mainButtonIcon: String {
        if isFinished { return "checkmark.circle.fill" }
        if isRunning  { return "pause.fill" }
        return "play.fill"
    }

    var mainButtonLabel: String {
        if isFinished { return "Complete! Great work!" }
        if isRunning  { return "Pause" }
        if secondsRemaining < activity.duration { return "Resume" }
        return "Start"
    }

    // Activity-specific image — falls back to coach image
    var activityImageName: String {
        let key = activity.name
            .lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
        // Check if asset exists — if not use coach image
        if UIImage(named: "\(coach.rawValue)_\(key)") != nil {
            return "\(coach.rawValue)_\(key)"
        }
        return coach.imageName
    }

    func handleMainButton() {
        if isFinished {
            timerTask?.cancel()
            onComplete()
            return
        }

        if isRunning {
            // Pause
            timerTask?.cancel()
            timerTask = nil
            isRunning = false
            coachBounce = false
            pulseRing = false
        } else {
            // Start or Resume
            isRunning = true
            coachBounce = true
            pulseRing = true
            startTimer()
        }
    }

    func startTimer() {
        timerTask = Task {
            while secondsRemaining > 0 {
                try? await Task.sleep(for: .seconds(1))
                if Task.isCancelled { return }
                await MainActor.run {
                    secondsRemaining -= 1
                }
            }
            await MainActor.run {
                isRunning = false
                isFinished = true
                coachBounce = false
                pulseRing = false
            }
        }
    }
}
