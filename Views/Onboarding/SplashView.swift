//
//  SplashView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI

struct SplashView: View {
    @State private var bounceKoala = false
    @State private var bouncePanda = false
    @State private var bounceSquirrel = false
    @State private var showTagline = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Animated animal trio
                HStack(spacing: 16) {
                    Text("🐨")
                        .font(.system(size: 52))
                        .offset(y: bounceKoala ? -12 : 0)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                            .delay(0.0),
                            value: bounceKoala
                        )

                    Text("🐼")
                        .font(.system(size: 60))
                        .offset(y: bouncePanda ? -12 : 0)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                            .delay(0.2),
                            value: bouncePanda
                        )

                    Text("🐿️")
                        .font(.system(size: 52))
                        .offset(y: bounceSquirrel ? -12 : 0)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                            .delay(0.4),
                            value: bounceSquirrel
                        )
                }
                .padding(.bottom, 32)

                // App name
                Text("Zest Zoo")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .foregroundColor(.black)

                // Tagline
                if showTagline {
                    Text("Movement Made Fun")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .padding(.top, 8)
                }

                Spacer()

                // Bottom label
                Text("Let's find your perfect coach!")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.gray.opacity(0.7))
                    .padding(.bottom, 48)
            }
        }
        .onAppear {
            bounceKoala = true
            bouncePanda = true
            bounceSquirrel = true
            withAnimation(.easeIn(duration: 0.6).delay(0.5)) {
                showTagline = true
            }
        }
    }
}
