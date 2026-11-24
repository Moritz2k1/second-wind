//
//  TabView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 19.11.26.
//

import SwiftUI

// Main navigation - tab bar at the bottom
struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "figure.run") {
                HomeView()
            }
            
            Tab("History", systemImage: "clock.arrow.circlepath") {
                ComingSoonView(title: "History", systemImage: "clock.arrow.circlepath")
            }
            
            Tab("Profile", systemImage: "person.crop.circle") {
                ComingSoonView(title: "Profile", systemImage: "person.crop.circle")
            }
        }
        .tint(ColorToken.accent)
    }
}

#Preview {
    MainTabView()
}
