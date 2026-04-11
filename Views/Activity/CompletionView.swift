//
//  CompletionView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI

struct CompletionView: View {
    let activity: Activity
    let coach: Coach
    let currencyEarned: Int
    let onDismiss: () -> Void

    @State private var showCheck = false
    @State private var showReward = false
    @State private var showButton = false
    @State private var scaleCheck = 0.3

    var body: some View {
        ZStack {
            Color(hex: "#F5F5F7").ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(coach.primaryColor)
                        .frame(width: 110, height: 110)
                        .scaleEffect(showCheck ? 1.0 : scaleCheck)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showCheck)

                    Image(systemName: "checkmark")
                        .font(.system(size: 48, weight: .black))
                        .foregroundColor(.white)
                        .opacity(showCheck ? 1 : 0)
                        .animation(.easeIn(duration: 0.3).delay(0.3), value: showCheck)
                }
                .padding(.bottom, 36)

                Text("Well Done!")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(.black)

                Text("You earned your reward")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .padding(.bottom, 32)

                if showReward {
                    VStack(spacing: 12) {
                        Text(coach.currencyEmoji)
                            .font(.system(size: 52))

                        Text("+\(currencyEarned)")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundColor(.green)

                        Text(coach.currencyName)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 160, height: 160)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 4)
                    .transition(.scale.combined(with: .opacity))
                }

                Spacer()

                if showButton {
                    Button(action: onDismiss) {
                        Text("Keep Going \(coach.emoji)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(coach.primaryColor)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear {
            withAnimation { showCheck = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.6)) { showReward = true }
            withAnimation(.easeOut(duration: 0.4).delay(1.0)) { showButton = true }
        }
    }
}
