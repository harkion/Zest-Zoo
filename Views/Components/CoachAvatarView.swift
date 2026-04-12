//
//  CoachAvatarView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI

struct CoachAvatarView: View {
    let coach: Coach
    let size: CGFloat

    init(coach: Coach, size: CGFloat = 80) {
        self.coach = coach
        self.size = size
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(coach.primaryColor)
                .frame(width: size, height: size)

            Image(coach.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.75, height: size * 0.75)
        }
    }
}

// Currency icon — uses asset or falls back to emoji
struct CurrencyIconView: View {
    let coach: Coach
    let size: CGFloat

    init(coach: Coach, size: CGFloat = 28) {
        self.coach = coach
        self.size = size
    }

    var body: some View {
        Image(coach.currencyImageName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}
