//
//  TabView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 19.11.26.
//

import SwiftUI
import SwiftData

// Main navigation - tab bar at the bottom
struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "figure.run") {
                HomeView()
            }
            
            Tab("History", systemImage: "clock.arrow.circlepath") {
                HistoryView()
            }
            
            Tab("Profile", systemImage: "person.crop.circle") {
                ProfileView()
            }
        }
        .tint(ColorToken.accent)
    }
}

#Preview {
    MainTabView()
        .modelContainer(.preview).environment(ProfileStore())
}
