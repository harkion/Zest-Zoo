//
//  Shop.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI

struct ShopView: View {
    @Environment(AppState.self) private var appState

    var coach: Coach {
        appState.currentUser?.assignedCoach ?? .koala
    }

    var balance: Int {
        appState.currentUser?.currencyBalance ?? 0
    }

    let shopItems: [ShopItem] = [
        ShopItem(name: "Cozy Hoodie", description: "A warm hoodie for your coach",
                 cost: 50, icon: "tshirt.fill", category: "Outfits"),
        ShopItem(name: "Party Hat", description: "Celebrate in style",
                 cost: 30, icon: "party.popper.fill", category: "Accessories"),
        ShopItem(name: "Sunglasses", description: "Too cool for school",
                 cost: 40, icon: "sunglasses.fill", category: "Accessories"),
        ShopItem(name: "Forest Theme", description: "A peaceful forest background",
                 cost: 80, icon: "tree.fill", category: "Backgrounds"),
        ShopItem(name: "Ocean Theme", description: "Calm ocean vibes",
                 cost: 80, icon: "water.waves", category: "Backgrounds"),
        ShopItem(name: "Night Theme", description: "Dark mode for your coach card",
                 cost: 100, icon: "moon.stars.fill", category: "Backgrounds")
    ]

    var categories: [String] {
        Array(Set(shopItems.map { $0.category })).sorted()
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Balance card
                HStack(spacing: 12) {
                    Text(coach.currencyEmoji)
                        .font(.system(size: 32))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(balance)")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text("Your \(coach.currencyName)")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    Text("Earn more by moving!")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 90)
                }
                .padding(20)
                .background(
                    LinearGradient(
                        colors: [coach.primaryColor, coach.primaryColor.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 24)

                // Items by category
                ForEach(categories, id: \.self) { category in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(category)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .padding(.horizontal, 20)

                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 12
                        ) {
                            ForEach(shopItems.filter { $0.category == category }) { item in
                                ShopItemCard(item: item, coach: coach, balance: balance)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 24)
                }

                Text("More items coming soon! 🔜")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)
            }
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Shop")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ShopItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let cost: Int
    let icon: String
    let category: String
}

struct ShopItemCard: View {
    let item: ShopItem
    let coach: Coach
    let balance: Int
    @State private var purchased = false

    var canAfford: Bool { balance >= item.cost }

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(coach.primaryColor.opacity(0.12))
                    .frame(width: 60, height: 60)
                Image(systemName: item.icon)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(coach.primaryColor)
            }

            Text(item.name)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

            Text(item.description)
                .font(.system(size: 11, weight: .regular, design: .rounded))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Button {
                if canAfford && !purchased {
                    purchased = true
                }
            } label: {
                HStack(spacing: 4) {
                    Text(coach.currencyEmoji)
                        .font(.system(size: 13))
                    Text(purchased ? "Owned" : "\(item.cost)")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(purchased ? .gray : canAfford ? .white : .gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    purchased ? Color.gray.opacity(0.15) :
                    canAfford ? coach.primaryColor : Color.gray.opacity(0.15)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(purchased || !canAfford)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}
