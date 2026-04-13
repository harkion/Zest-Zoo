//
//  WeeklyProgressView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI
import SwiftData

struct WeeklyProgressView: View {
    @Environment(AppState.self) private var appState
    @Query(sort: \ActivityRecord.completedAt, order: .reverse)
    private var allRecords: [ActivityRecord]

    var user: User? { appState.currentUser }

    var coach: Coach {
        user?.assignedCoach ?? .koala
    }

    var weekDays: [WeekDay] {
        let calendar = Calendar.current
        let today = Date()

        guard let weekInterval = calendar.dateInterval(
            of: .weekOfYear, for: today
        ) else { return [] }

        var days: [WeekDay] = []
        for i in 0..<7 {
            guard let date = calendar.date(
                byAdding: .day, value: i, to: weekInterval.start
            ) else { continue }

            let dayRecords = allRecords.filter {
                calendar.isDate($0.completedAt, inSameDayAs: date)
            }

            let minutes = dayRecords.reduce(0) { $0 + ($1.durationSeconds / 60) }
            let isToday = calendar.isDateInToday(date)
            let isPast = date < today && !isToday

            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"

            days.append(WeekDay(
                label: formatter.string(from: date),
                date: date,
                minutes: minutes,
                sessions: dayRecords.count,
                isToday: isToday,
                isPast: isPast
            ))
        }
        return days
    }

    var weeklyTotal: Int { user?.weeklyMinutes ?? 0 }
    var weeklyGoal: Int { user?.weeklyGoalMinutes ?? 35 }

    var progressPercent: Double {
        guard weeklyGoal > 0 else { return 0 }
        return min(Double(weeklyTotal) / Double(weeklyGoal), 1.0)
    }

    var maxMinutes: Int {
        max(weekDays.map { $0.minutes }.max() ?? 1, 1)
    }

    var thisWeekRecords: [ActivityRecord] {
        guard let weekStart = Calendar.current.dateInterval(
            of: .weekOfYear, for: Date()
        )?.start else { return [] }
        return allRecords.filter { $0.completedAt >= weekStart }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // MARK: - Goal progress card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Weekly Goal")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.gray)
                                .textCase(.uppercase)
                                .tracking(0.8)
                            Text("\(weeklyTotal) / \(weeklyGoal) min")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundColor(.black)
                        }
                        Spacer()

                        // Circular progress
                        ZStack {
                            Circle()
                                .stroke(coach.primaryColor.opacity(0.15), lineWidth: 8)
                                .frame(width: 64, height: 64)
                            Circle()
                                .trim(from: 0, to: progressPercent)
                                .stroke(
                                    coach.primaryColor,
                                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                )
                                .frame(width: 64, height: 64)
                                .rotationEffect(.degrees(-90))
                                .animation(.spring(duration: 0.8), value: progressPercent)
                            Text("\(Int(progressPercent * 100))%")
                                .font(.system(size: 14, weight: .black, design: .rounded))
                                .foregroundColor(coach.primaryColor)
                        }
                    }

                    // Linear bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.gray.opacity(0.12))
                                .frame(height: 10)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(progressPercent >= 1 ? Color.green : coach.primaryColor)
                                .frame(
                                    width: geo.size.width * progressPercent,
                                    height: 10
                                )
                                .animation(.spring(duration: 0.8), value: progressPercent)
                        }
                    }
                    .frame(height: 10)

                    HStack {
                        if progressPercent >= 1 {
                            Label("Goal reached this week!", systemImage: "checkmark.circle.fill")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(.green)
                        } else {
                            Text("\(weeklyGoal - weeklyTotal) min to go")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("Resets Monday")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(.gray.opacity(0.7))
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)

                // MARK: - Bar chart
                VStack(alignment: .leading, spacing: 16) {
                    Text("Daily Breakdown")
                        .font(.system(size: 16, weight: .bold, design: .rounded))

                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(weekDays) { day in
                            DayBarView(
                                day: day,
                                maxMinutes: maxMinutes,
                                coach: coach
                            )
                        }
                    }
                    .frame(height: 140)
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)

                // MARK: - Stats row
                VStack(alignment: .leading, spacing: 14) {
                    Text("This Week")
                        .font(.system(size: 16, weight: .bold, design: .rounded))

                    HStack(spacing: 12) {
                        WeekStatCard(
                            icon: "bolt.fill",
                            iconColor: coach.primaryColor,
                            value: "\(thisWeekRecords.count)",
                            label: "Sessions"
                        )
                        WeekStatCard(
                            icon: "flame.fill",
                            iconColor: .orange,
                            value: "\(user?.currentStreak ?? 0)",
                            label: "Day Streak"
                        )
                        WeekStatCard(
                            icon: "clock.fill",
                            iconColor: .blue,
                            value: "\(weeklyTotal)",
                            label: "Minutes"
                        )
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)

                // MARK: - Coach message
                HStack(spacing: 14) {
                    Image(coach.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)

                    Text(weeklyCoachMessage)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(16)
                .background(coach.secondaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Spacer().frame(height: 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Weekly Progress")
        .navigationBarTitleDisplayMode(.large)
    }

    var weeklyCoachMessage: String {
        let percent = Int(progressPercent * 100)
        switch coach {
        case .koala:
            if percent >= 100 { return "You did it. Every single minute mattered. Now rest, you've earned it." }
            if percent >= 50  { return "Over halfway there… no rush. Just keep showing up, that's everything." }
            return "Hey. Still early in the week. No pressure. We just need a little movement, that's all."
        case .panda:
            if percent >= 100 { return "Weekly goal done! That's the consistency I'm talking about. Bamboo for everyone." }
            if percent >= 50  { return "More than halfway! You know what that means — you're already doing it. Keep going." }
            return "New week, fresh start. A little bamboo, a little movement. Balance is everything."
        case .squirrel:
            if percent >= 100 { return "GOAL CRUSHED. Every session this week counted. That's how it's done. NEXT WEEK." }
            if percent >= 50  { return "More than halfway! Don't stop now — the second half is where legends are made." }
            return "Week just started. Let's make every single day count. Clock's already ticking. GO."
        }
    }
}

// MARK: - Week Day Model
struct WeekDay: Identifiable {
    let id = UUID()
    let label: String
    let date: Date
    let minutes: Int
    let sessions: Int
    let isToday: Bool
    let isPast: Bool
}

// MARK: - Day Bar View
struct DayBarView: View {
    let day: WeekDay
    let maxMinutes: Int
    let coach: Coach

    var barHeight: CGFloat {
        guard maxMinutes > 0, day.minutes > 0 else { return 4 }
        return max(CGFloat(day.minutes) / CGFloat(maxMinutes) * 100, 4)
    }

    var barColor: Color {
        if day.isToday    { return coach.primaryColor }
        if day.minutes > 0 { return coach.primaryColor.opacity(0.5) }
        return Color.gray.opacity(0.15)
    }

    var body: some View {
        VStack(spacing: 6) {
            if day.minutes > 0 {
                Text("\(day.minutes)m")
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .foregroundColor(coach.primaryColor)
            } else {
                Text(" ")
                    .font(.system(size: 9))
            }

            Spacer()

            RoundedRectangle(cornerRadius: 6)
                .fill(barColor)
                .frame(height: barHeight)
                .animation(.spring(duration: 0.6), value: barHeight)

            Text(day.label)
                .font(.system(
                    size: 11,
                    weight: day.isToday ? .black : .medium,
                    design: .rounded
                ))
                .foregroundColor(day.isToday ? coach.primaryColor : .gray)

            Circle()
                .fill(day.isToday ? coach.primaryColor : Color.clear)
                .frame(width: 5, height: 5)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Week Stat Card
struct WeekStatCard: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(iconColor)
            Text(value)
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(.black)
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(hex: "#F5F5F7"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
