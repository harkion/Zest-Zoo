import SwiftUI

struct CoachRevealView: View {
    let coach: Coach
    let onContinue: () -> Void

    @State private var showCircle = false
    @State private var showEmoji = false
    @State private var showName = false
    @State private var showDescription = false
    @State private var showButton = false
    @State private var emojiScale: CGFloat = 0.3
    @State private var pulseRing = false

    var body: some View {
        ZStack {
            coach.secondaryColor.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Pulsing ring behind avatar
                ZStack {
                    Circle()
                        .stroke(coach.primaryColor.opacity(0.2), lineWidth: 2)
                        .frame(width: pulseRing ? 220 : 180, height: pulseRing ? 220 : 180)
                        .animation(
                            .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                            value: pulseRing
                        )

                    Circle()
                        .fill(coach.primaryColor)
                        .frame(width: showCircle ? 160 : 0, height: showCircle ? 160 : 0)
                        .animation(.spring(duration: 0.6).delay(0.2), value: showCircle)

                    Image(coach.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: showEmoji ? 100 : 20,
                            height: showEmoji ? 100 : 20
                        )
                        .scaleEffect(emojiScale)
                }
                .padding(.bottom, 40)

                // Coach name
                if showName {
                    Text("Meet \(coach.nickname)!")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(coach.primaryColor)
                        .textCase(.uppercase)
                        .tracking(1.5)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))

                    Text(coach.displayName)
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.black)
                        .padding(.top, 4)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                // Description
                if showDescription {
                    Text(coachDescription)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 36)
                        .padding(.top, 16)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))

                    // Currency preview
                    HStack(spacing: 8) {
                        Text(coach.currencyEmoji)
                            .font(.system(size: 24))
                        Text("You'll earn \(coach.currencyName)")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(coach.primaryColor)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(coach.primaryColor.opacity(0.12))
                    .clipShape(Capsule())
                    .padding(.top, 20)
                    .transition(.opacity.combined(with: .scale))
                }

                Spacer()

                // CTA button
                if showButton {
                    Button(action: onContinue) {
                        Text("Let's Go! \(coach.emoji)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(coach.primaryColor)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear { runAnimation() }
    }

    private var coachDescription: String {
        switch coach {
        case .koala:
            return "Koa is your go-to for gentle, low-pressure movement. No judgment, tiny wins, big results over time."
        case .panda:
            return "Bo keeps it balanced. Steady routines, friendly nudges, and just enough fun to keep you coming back."
        case .squirrel:
            return "Zip is all about fast, efficient bursts. Short on time? Perfect. Let's make every minute count."
        }
    }

    private func runAnimation() {
        withAnimation { showCircle = true }
        withAnimation(.spring().delay(0.5)) {
            showEmoji = true
            emojiScale = 1.0
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.8)) { showName = true }
        withAnimation(.easeOut(duration: 0.5).delay(1.1)) { showDescription = true }
        withAnimation(.easeOut(duration: 0.5).delay(1.5)) { showButton = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { pulseRing = true }
    }
}
