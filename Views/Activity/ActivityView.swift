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

    init(activity: Activity, coach: Coach, onComplete: @escaping () -> Void) {
        self.activity = activity
        self.coach = coach
        self.onComplete = onComplete
        _secondsRemaining = State(initialValue: activity.duration)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text(coach.emoji)
                        .font(.system(size: 72))

                    Text(activity.name)
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .multilineTextAlignment(.center)

                    Text(activity.description)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 10) {
                    Text(timeText)
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(coach.primaryColor)

                    ProgressView(value: progress)
                        .tint(coach.primaryColor)
                }

                Spacer()

                Button(action: onComplete) {
                    Text("Finish Session")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(coach.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#F5F5F7"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            while secondsRemaining > 0 {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled, secondsRemaining > 0 else { return }
                secondsRemaining -= 1
            }
        }
    }

    private var progress: Double {
        guard activity.duration > 0 else { return 1 }
        return Double(activity.duration - secondsRemaining) / Double(activity.duration)
    }

    private var timeText: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
