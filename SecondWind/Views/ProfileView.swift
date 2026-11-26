//
//  ProfileView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import SwiftUI
import SwiftData

/// User details and personal training zones
struct ProfileView: View {
    
    // Shared profile, updates when edited
    @Environment(ProfileStore.self) private var profileStore
    
    // Opens edit sheet
    @State private var showsEditSheet: Bool = false
    
    // Stored on device - on by default
    @AppStorage(Configuration.audioFeedbackKey) private var isFeedbackEnabled: Bool = true
    
    // How often and how late feedback starts, defaults from Configuration
    @AppStorage(Configuration.feedbackIntervalKey) private var feedbackInterval: TimeInterval = Configuration.feedbackInterval
    
    @AppStorage(Configuration.feedbackWarmupKey) private var feedbackWarmup: TimeInterval = Configuration.feedbackWarmup
    
    // Shared connection, for strap status
    @EnvironmentObject private var bluetooth: CoreBluetoothService
    
    // Saved runs, for count and deleting
    @Query private var runs: [Run]
    @Environment(\.modelContext) private var modelContext
    
    // Asks before deleting
    @State private var showsDeleteConfirmation: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.large) {
                ScreenHeader(title: "Profile")
                
                if let profile = profileStore.profile {
                    profileCard(profile)
                    zonesCard(profile)
                    feedbackCard
                    strapCard
                    dataCard
                    aboutCard
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
        .confirmationDialog("Delete all runs?", isPresented: $showsDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete all runs", role: .destructive) {
                deleteAllRuns()
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This can't be undone. Your profile and zones stay.")
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
                
                Text(profile.hasCustomMaxHeartRate ? "Based on your own max heart rate" : "Based on your estimated max heart rate")
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
            .tint(ColorToken.toggleTint)
            
            Text("Says \"Faster\" or \"Slower\" when you leave your target zone")
                .font(.subheadline)
                .foregroundStyle(ColorToken.secondaryText)
            
            // Details only matter when feedback is on
            if isFeedbackEnabled {
                SettingRow(
                    title: "Repeat at most every",
                    selection: $feedbackInterval,
                    options: Configuration.feedbackIntervalOptions
                )
                
                SettingRow(
                    title: "Quiet at start",
                    selection: $feedbackWarmup,
                    options: Configuration.feedbackWarmupOptions
                )
            }
        }
        .cardStyle()
    }
    
    // Which strap is used + connection status
    private var strapCard: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Label("Chest strap", systemImage: "heart.circle")
                .font(.headline)
                .foregroundStyle(ColorToken.primaryText)
            
            VStack(alignment: .leading, spacing: Spacing.small / 2) {
                Text(bluetooth.deviceName ?? "No strap connected yet")
                    .font(.body)
                    .foregroundStyle(ColorToken.primaryText)
                
                Text("Works with Polar H10, connect on Home")
                    .font(.subheadline)
                    .foregroundStyle(ColorToken.secondaryText)
            }
            
            ConnectionPill(
                text: bluetooth.isConnected ? "Connected" : "Not connected",
                isConnected: bluetooth.isConnected,
                isScanning: bluetooth.isScanning
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
    
    // Number of saved runs and option to delete them
    private var dataCard: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Label("Data", systemImage: "externaldrive")
                .font(.headline)
                .foregroundStyle(ColorToken.primaryText)
            
            Text("^[\(runs.count) run](inflect: true) saved on this device")
                .font(.subheadline)
                .foregroundStyle(ColorToken.secondaryText)
            
            Button("Delete all runs") { showsDeleteConfirmation = true }
                .buttonStyle(.destructive)
                .disabled(runs.isEmpty)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
    
    // App version
    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Label("About", systemImage: "info.circle")
                .font(.headline)
                .foregroundStyle(ColorToken.primaryText)
            
            InfoRow(title: "Version", value: AppInfo.fullVersion)
            InfoRow(title: "Max heart rate formula", value: "Tanaka (2001)")
            
            Text("Second Wind is not a medical device. Zones are estimates.")
                .font(.footnote)
                .foregroundStyle(ColorToken.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
    
    /// Removes every saved run
    private func deleteAllRuns() {
        
        for run in runs {
            modelContext.delete(run)
        }
        
        try? modelContext.save()
    }
}

/// Label on the left, menu with time choices on the right
private struct SettingRow: View {
    
    let title: String
    @Binding var selection: TimeInterval
    let options: [TimeInterval]
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(ColorToken.primaryText)
            
            Spacer()
            
            // Shows selected value, tap opens list of options
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { seconds in
                    Text(RunFormat.setting(seconds))
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .tint(ColorToken.toggleTint)
        }
    }
}

/// Label on the left, value on the right
private struct InfoRow: View {
    
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(ColorToken.secondaryText)
            
            Spacer()
            
            Text(value)
                .foregroundStyle(ColorToken.primaryText)
        }
        .font(.subheadline)
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
        .environmentObject(CoreBluetoothService())
        .modelContainer(.preview)
}
