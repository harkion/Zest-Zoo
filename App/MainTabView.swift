//
//  MainTabView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                Text("Home")
            }
            .tag(0)

            NavigationStack {
                FriendsView()
            }
            .tabItem {
                Image(systemName: selectedTab == 1 ? "person.2.fill" : "person.2")
                Text("Friends")
            }
            .tag(1)

            NavigationStack {
                ShopView()
            }
            .tabItem {
                Image(systemName: selectedTab == 2 ? "bag.fill" : "bag")
                Text("Shop")
            }
            .tag(2)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                Text("Profile")
            }
            .tag(3)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Settings")
            }
            .tag(4)
        }
        .tint(.blue)
    }
}
