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
    @State private var showAnimals = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Animals appear with fade in first
                HStack(spacing: 20) {
                    Text("🐨")
                        .font(.system(size: 52))
                        .offset(y: bounceKoala ? -14 : 0)
                        .animation(
                            .easeInOut(duration: 0.7)
                            .repeatForever(autoreverses: true)
                            .delay(0.0),
                            value: bounceKoala
                        )

                    Text("🐼")
                        .font(.system(size: 64))
                        .offset(y: bouncePanda ? -14 : 0)
                        .animation(
                            .easeInOut(duration: 0.7)
                            .repeatForever(autoreverses: true)
                            .delay(0.25),
                            value: bouncePanda
                        )

                    Text("🐿️")
                        .font(.system(size: 52))
                        .offset(y: bounceSquirrel ? -14 : 0)
                        .animation(
                            .easeInOut(duration: 0.7)
                            .repeatForever(autoreverses: true)
                            .delay(0.5),
                            value: bounceSquirrel
                        )
                }
                .opacity(showAnimals ? 1 : 0)
                .scaleEffect(showAnimals ? 1 : 0.7)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: showAnimals)
                .padding(.bottom, 36)

                // App name
                Text("Zest Zoo")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundColor(.black)

                // Tagline fades in after
                Text("Movement Made Fun")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .opacity(showTagline ? 1 : 0)
                    .offset(y: showTagline ? 0 : 10)
                    .animation(.easeOut(duration: 0.5).delay(0.4), value: showTagline)
                    .padding(.top, 8)

                Spacer()

                Text("Finding your perfect coach…")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.gray.opacity(0.6))
                    .opacity(showTagline ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.7), value: showTagline)
                    .padding(.bottom, 52)
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            // Slight delay so the view is fully laid out
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                showAnimals = true
                bounceKoala = true
                bouncePanda = true
                bounceSquirrel = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showTagline = true
            }
        }
    }
}
