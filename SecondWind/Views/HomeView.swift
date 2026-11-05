//
//  HomeView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 05.11.26.
//

import SwiftUI
import SwiftData

// Placeholder for main screen
struct HomeView: View {
    
    // Loaded once
    private let profile: UserProfile? = UserProfile.loadProfile()
    
    var body: some View {
        if let profile: UserProfile = profile {
            VStack(spacing: 12) {
                Text("Welcome, \(profile.username)")
                    .font(.title)
                
                Text("Estimated max heart rate: \(profile.maxHeartRate) bpm")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    HomeView()
}
