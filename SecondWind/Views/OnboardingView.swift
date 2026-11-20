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
        ScrollView {
            VStack(spacing: Spacing.extraLarge) {
                hero
                header
                infoCard
            }
            .padding(.horizontal, Spacing.large)
            .padding(.top, Spacing.extraLarge)
            .padding(.bottom, Spacing.large)
        }
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            startButton
        }
        .screenBackground()
    }
    
    private var hero: some View {
        ZStack {
            Circle()
                .fill(ColorToken.accent.opacity(0.06))
                .frame(width: 200, height: 200)
            
            Circle()
                .fill(ColorToken.accent.opacity(0.12))
                .frame(width: 150, height: 150)
            
            Circle()
                .stroke(ColorToken.accent.opacity(0.35), lineWidth: 1)
                .frame(width: 150, height: 150)
            
            heart
        }
    }
    
    private var heart: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 64, weight: .semibold))
            .foregroundStyle(ColorToken.accent)
            .symbolEffect(.pulse, options: .repeating)
            .shadow(color: ColorToken.accent.opacity(0.6), radius: 20)
    }
    
    private var header: some View {
        ScreenHeader(
            title: "Chest strap required",
            subtitle: "Second Wind needs a Polar H10 to precisely measure your heart"
        )
    }
    
    private var infoCard: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            OnboardingInfoRow(
                systemImage: "waveform.path.ecg",
                title: "Beat-to-beat accuracy",
                description: "The iPhone alone cannot measure the time between heartbeats accurately enough"
            )
            
            
            OnboardingInfoRow(
                systemImage: "antenna.radiowaves.left.and.right",
                title: "Connects via Bluetooth",
                description: "Put on your strap and the app pairs with it automatically"
            )
            
            
            OnboardingInfoRow(
                systemImage: "checkmark.seal.fill",
                title: "Supported device",
                description: "Polar H10"
            )
        }
        .cardStyle()
    }
    
    private var startButton: some View {
        Button("Get started") {
            hasSeenOnboarding = true
        }
        .buttonStyle(.primary)
        .padding(.all, Spacing.large)
    }
}

/// Row with icon, title, description
private struct OnboardingInfoRow: View {
    
    let systemImage: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.medium) {
            icon
            text
        }
    }
    
    private var icon: some View {
        Image(systemName: systemImage)
            .font(.title3)
            .foregroundStyle(ColorToken.accent)
            .frame(width: 44, height: 44)
            .background(ColorToken.iconBackground)
            .clipShape(RoundedRectangle(cornerRadius: Radius.button))
    }
    
    private var text: some View {
        VStack(alignment: .leading, spacing: Spacing.small / 2) {
            Text(title)
                .font(.headline)
                .foregroundStyle(ColorToken.primaryText)
            
            Text(description)
                .font(.subheadline)
                .foregroundStyle(ColorToken.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    OnboardingView()
}
