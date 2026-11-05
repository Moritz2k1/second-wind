//
//  OnboardingView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 05.11.26.
//

import SwiftUI

// First screen after installing app
struct OnboardingView: View {
    
    // Same key as in RootView, set to true -> next screen
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.red)
            
            Text("Chest strap required")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("This app needs a Polar H10 to work properly.")
                .font(.body)
                .multilineTextAlignment(.center)
            
            Text("The iPhone alone can't measure the time between heartbeats accurately enough.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 12) {
                Label("Polar H10", systemImage: "checkmark.circle.fill")
            }
            .font(.headline)
            
            Spacer()
            
            Button {
                hasSeenOnboarding = true
            } label: {
                Text("Got it")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(24)
    }
}

#Preview {
    OnboardingView()
}
