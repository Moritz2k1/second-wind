//
//  ProfileView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import SwiftUI

/// User details and personal training zones
struct ProfileView: View {
    
    // Shared profile, updates when edited
    @Environment(ProfileStore.self) private var profileStore
    
    // Opens edit sheet
    @State private var showsEditSheet: Bool = false
    
    // Stored on device - on by default
    @AppStorage(Configuration.audioFeedbackKey) private var isFeedbackEnabled: Bool = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.large) {
                ScreenHeader(title: "Profile", alignment: .leading)
                
                if let profile = profileStore.profile {
                    profileCard(profile)
                    zonesCard(profile)
                    feedbackCard
                }
            }
            .padding(.horizontal, Spacing.large)
            .padding(.vertical, Spacing.large)
        }
        .scrollBounceBehavior(.basedOnSize)
        .screenBackground()
        .sheet(isPresented: $showsEditSheet) {
            if let profile = profileStore.profile {
                EditProfileView(profile: profile)
            }
        }
    }
    
    // Initials, name, age and max heart rate
    private func profileCard(_ profile: UserProfile) -> some View {
        VStack(spacing: Spacing.medium) {
            HStack(spacing: Spacing.medium) {
                Text(profile.initials)
                    .font(.title2.bold())
                    .foregroundStyle(ColorToken.avatarText)
                    .frame(width: 64, height: 64)
                    .background(ColorToken.avatarBackground)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: Spacing.small / 2) {
                    Text(profile.username)
                        .font(.sectionTitle)
                        .foregroundStyle(ColorToken.primaryText)
                    
                    Text("\(profile.age) years · Max HR \(profile.maxHeartRate) bpm")
                        .font(.subheadline)
                        .foregroundStyle(ColorToken.secondaryText)
                }
                
                Spacer()
            }
            
            Button("Edit profile") { showsEditSheet = true }
                .buttonStyle(.secondary)
        }
        .cardStyle()
    }
    
    // All five zones with personal bpm ranges
    private func zonesCard(_ profile: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            VStack(alignment: .leading, spacing: Spacing.small / 2) {
                Text("Your zones")
                    .font(.headline)
                    .foregroundStyle(ColorToken.primaryText)
                
                Text("Based on your estimated max heart rate")
                    .font(.subheadline)
                    .foregroundStyle(ColorToken.secondaryText)
            }
            
            ForEach(TrainingZone.zones) { zone in
                ZoneRow(zone: zone, maxHeartRate: profile.maxHeartRate)
            }
        }
        .cardStyle()
    }
    
    // Turns audio feedback on or off
    private var feedbackCard: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Toggle(isOn: $isFeedbackEnabled) {
                Label("Audio feedback", systemImage: "speaker.wave.2.fill")
                    .font(.headline)
                    .foregroundStyle(ColorToken.primaryText)
            }
            
            Text("Says \"Faster\" or \"Slower\" when you leave your target zone")
                .font(.subheadline)
                .foregroundStyle(ColorToken.secondaryText)
        }
        .cardStyle()
    }
}

/// One zone with badge, bpm range and position on scale
private struct ZoneRow: View {
    
    let zone: TrainingZone
    let maxHeartRate: Int
    
    // Scale starts at 50% of max heart rate
    private let scaleStart: Double = 0.5
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            HStack {
                ZoneBadge(zone: zone)
                
                Spacer()
                
                Text(RunFormat.heartRateRange(of: zone, maxHeartRate: maxHeartRate))
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(ColorToken.primaryText)
            }
            
            scaleBar
        }
    }
    
    // Colored part shows where zone sits between 50% and 100%
    private var scaleBar: some View {
        Capsule()
            .fill(ColorToken.progressTrack)
            .frame(height: 6)
            .overlay(alignment: .leading) {
                GeometryReader { proxy in
                    Capsule()
                        .fill(Color.zoneColor(zoneId: zone.id))
                        .frame(width: proxy.size.width * widthShare)
                        .offset(x: proxy.size.width * startShare)
                }
            }
    }
    
    /// Where zone starts on scale
    private var startShare: Double {
        (zone.minPercent - scaleStart) / (1 - scaleStart)
    }
    
    /// How much of scale zone covers
    private var widthShare: Double {
        (zone.maxPercent - zone.minPercent) / (1 - scaleStart)
    }
}

#Preview {
    ProfileView()
        .environment(ProfileStore(profile: .sample))
}
