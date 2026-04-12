//
//  AboutView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 12/04/2026.
//

import SwiftUI

struct AboutView: View {
    @Environment(AppState.self) private var appState

    var coach: Coach {
        appState.currentUser?.assignedCoach ?? .koala
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // App identity card
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(coach.primaryColor)
                            .frame(width: 90, height: 90)
                        Image(coach.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }

                    VStack(spacing: 6) {
                        Text("Zest Zoo")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                        Text("Version 1.0.0")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                        Text("Movement Made Fun")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(coach.primaryColor)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(28)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.04), radius: 8)

                // Mission
                VStack(alignment: .leading, spacing: 12) {
                    Label("Our Mission", systemImage: "heart.fill")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(coach.primaryColor)

                    Text("At Zest Zoo, we believe that staying active doesn't mean spending hours at the gym. Small, frequent movements throughout your day can make a big difference in your health, energy, and happiness. Our mission is to make movement fun, accessible, and rewarding for everyone.")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.04), radius: 8)

                // What we do
                VStack(alignment: .leading, spacing: 16) {
                    Text("What We Do")
                        .font(.system(size: 16, weight: .bold, design: .rounded))

                    AboutFeatureRow(
                        icon: "figure.walk",
                        iconColor: coach.primaryColor,
                        title: "Personalized Coaching",
                        subtitle: "Get matched with a coach that fits your lifestyle — energetic Squirrel, balanced Panda, or gentle Koala."
                    )
                    AboutFeatureRow(
                        icon: "bolt.fill",
                        iconColor: .orange,
                        title: "Micro-Movements",
                        subtitle: "Quick 2–5 minute movement sessions that fit seamlessly into your busy schedule."
                    )
                    AboutFeatureRow(
                        icon: "person.2.fill",
                        iconColor: .blue,
                        title: "Community & Competition",
                        subtitle: "Connect with friends, join challenges, and celebrate wins together."
                    )
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.04), radius: 8)

                // Meet the coaches
                VStack(alignment: .leading, spacing: 16) {
                    Text("Meet Your Coaches")
                        .font(.system(size: 16, weight: .bold, design: .rounded))

                    ForEach(Coach.allCases, id: \.self) { c in
                        HStack(spacing: 14) {
                            CoachAvatarView(coach: c, size: 52)

                            VStack(alignment: .leading, spacing: 3) {
                                Text(c.displayName)
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(c.primaryColor)
                                Text(coachSubtitle(c))
                                    .font(.system(size: 13, weight: .regular, design: .rounded))
                                    .foregroundColor(.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                        }
                        .padding(14)
                        .background(c.secondaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.04), radius: 8)

                // App info footer
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Text("Made with")
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("for a healthier, happier you.")
                    }
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)

                    Text("© 2026 Zest Zoo. All rights reserved.")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(.gray.opacity(0.6))
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("About Zest Zoo")
        .navigationBarTitleDisplayMode(.large)
    }

    func coachSubtitle(_ coach: Coach) -> String {
        switch coach {
        case .koala:    return "Gentle & Relaxed — perfect for those who need the softest push."
        case .panda:    return "Balanced Approach — a healthy mix of movement and rest."
        case .squirrel: return "High Energy — fast, efficient bursts for busy lifestyles."
        }
    }
}

struct AboutFeatureRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
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
        }
    }
}
