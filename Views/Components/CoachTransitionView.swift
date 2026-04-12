//
//  CoachTransitionView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 12/04/2026.
//

import SwiftUI
import SwiftData

struct CoachTransitionView: View {
    let transition: CoachTransition
    let onComplete: () -> Void

    @State private var fromVisible = false
    @State private var messageVisible = false
    @State private var toVisible = false
    @State private var buttonVisible = false
    @State private var fromScale: CGFloat = 0.8
    @State private var toScale: CGFloat = 0.8
    @State private var pulseFrom = false
    @State private var pulseTo = false

    var isPromotion: Bool { transition.type == .promotion }

    var body: some View {
        ZStack {
            // Background blends between both coach colors
            LinearGradient(
                colors: [
                    transition.from.secondaryColor,
                    transition.to.secondaryColor
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Promotion / Demotion badge
                Text(isPromotion ? "⬆️ Level Up!" : "💙 Recovery Mode")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(isPromotion ? .green : .orange)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.85))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
                    .opacity(fromVisible ? 1 : 0)
                    .padding(.bottom, 36)

                // Two coaches side by side
                HStack(spacing: 32) {

                    // FROM coach
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .stroke(
                                    transition.from.primaryColor.opacity(0.3),
                                    lineWidth: 3
                                )
                                .frame(
                                    width: pulseFrom ? 108 : 96,
                                    height: pulseFrom ? 108 : 96
                                )
                                .animation(
                                    .easeInOut(duration: 1.2)
                                    .repeatForever(autoreverses: true),
                                    value: pulseFrom
                                )

                            Circle()
                                .fill(transition.from.primaryColor)
                                .frame(width: 88, height: 88)

                            Image(transition.from.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                        }
                        .scaleEffect(fromScale)
                        .opacity(fromVisible ? 1 : 0)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.7),
                            value: fromVisible
                        )

                        Text(transition.from.nickname)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.gray)
                            .opacity(fromVisible ? 1 : 0)

                        // "Leaving" label
                        Text(isPromotion ? "Your coach" : "Taking a break")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(.gray.opacity(0.7))
                            .opacity(fromVisible ? 1 : 0)
                    }

                    // Arrow between coaches
                    VStack(spacing: 4) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.gray.opacity(0.4))
                        Text(transition.message.objectPassed.isEmpty
                             ? "" : "🎁 \(transition.message.objectPassed)")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(.gray.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 60)
                    }
                    .opacity(toVisible ? 1 : 0)
                    .animation(.easeIn(duration: 0.4), value: toVisible)

                    // TO coach
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .stroke(
                                    transition.to.primaryColor.opacity(0.3),
                                    lineWidth: 3
                                )
                                .frame(
                                    width: pulseTo ? 108 : 96,
                                    height: pulseTo ? 108 : 96
                                )
                                .animation(
                                    .easeInOut(duration: 1.2)
                                    .repeatForever(autoreverses: true)
                                    .delay(0.4),
                                    value: pulseTo
                                )

                            Circle()
                                .fill(transition.to.primaryColor)
                                .frame(width: 88, height: 88)

                            Image(transition.to.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                        }
                        .scaleEffect(toScale)
                        .opacity(toVisible ? 1 : 0)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.7),
                            value: toVisible
                        )

                        Text(transition.to.nickname)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(transition.to.primaryColor)
                            .opacity(toVisible ? 1 : 0)

                        // "New" label
                        Text(isPromotion ? "New coach!" : "Your coach now")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(transition.to.primaryColor.opacity(0.8))
                            .opacity(toVisible ? 1 : 0)
                    }
                }
                .padding(.bottom, 40)

                // Message cards
                VStack(spacing: 12) {

                    // FROM coach speaks first
                    MessageCard(
                        coach: transition.from,
                        line: transition.message.fromCoachLine,
                        subline: transition.message.bridgeLine,
                        isVisible: messageVisible
                    )

                    // TO coach responds
                    if toVisible {
                        MessageCard(
                            coach: transition.to,
                            line: transition.message.toCoachLine,
                            subline: transition.message.farewell,
                            isVisible: toVisible,
                            isHighlighted: true
                        )
                        .transition(
                            .move(edge: .bottom)
                            .combined(with: .opacity)
                        )
                    }
                }
                .padding(.horizontal, 24)
                .animation(.spring(duration: 0.5), value: toVisible)

                Spacer()

                // CTA button
                if buttonVisible {
                    Button(action: onComplete) {
                        HStack(spacing: 10) {
                            Image(transition.to.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)

                            Text("Meet \(transition.to.nickname)!")
                                .font(.system(
                                    size: 18,
                                    weight: .bold,
                                    design: .rounded
                                ))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(transition.to.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(
                            color: transition.to.primaryColor.opacity(0.35),
                            radius: 12, x: 0, y: 4
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear { runAnimation() }
    }

    // MARK: - Animation sequence
    private func runAnimation() {
        // Step 1 — from coach enters
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
            fromVisible = true
            fromScale = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            pulseFrom = true
        }

        // Step 2 — message appears
        withAnimation(.easeOut(duration: 0.5).delay(0.8)) {
            messageVisible = true
        }

        // Step 3 — to coach enters with arrow
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(1.8)) {
            toVisible = true
            toScale = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            pulseTo = true
        }

        // Step 4 — button appears
        withAnimation(.easeOut(duration: 0.4).delay(2.6)) {
            buttonVisible = true
        }
    }
}

// MARK: - Message Card
struct MessageCard: View {
    let coach: Coach
    let line: String
    let subline: String
    let isVisible: Bool
    var isHighlighted: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Coach label
            HStack(spacing: 8) {
                Image(coach.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)

                Text(coach.nickname)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(coach.primaryColor)

                Image(systemName: "quote.opening")
                    .font(.system(size: 10))
                    .foregroundColor(coach.primaryColor.opacity(0.6))
            }

            // Main line
            Text(line)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)

            // Sub line
            Text(subline)
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            isHighlighted
                ? coach.secondaryColor
                : Color.white
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 12)
        .animation(.easeOut(duration: 0.4), value: isVisible)
    }
}
