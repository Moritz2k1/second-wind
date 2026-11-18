//
//  HomeView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 05.11.26.
//

import SwiftUI
import Charts

// Placeholder for main screen
struct HomeView: View {
    
    // Loaded once
    private let profile: UserProfile? = UserProfile.loadProfile()
    
    // Owns Bluetooth connection while Home Screen exists
    @StateObject private var bluetooth: CoreBluetoothService = CoreBluetoothService()
    
    var body: some View {
        Group {
            if let profile: UserProfile = profile {
                VStack(spacing: 12) {
                    Text("Welcome, \(profile.username)")
                        .font(.sectionTitle)
                    
                    Text("Estimated max heart rate: \(profile.maxHeartRate) bpm")
                        .foregroundStyle(Color.secondaryText)
                }
            }
        }
        .screenBackground()
    }
    
    private var currentZone: TrainingZone? {
        guard let profile, bluetooth.heartRate > 0 else { return nil }
        return TrainingZone.zone(HR: bluetooth.heartRate, maxHR: profile.maxHeartRate)
    }
    
    private var heartRateText: String {
        bluetooth.heartRate > 0 ? "\(bluetooth.heartRate)" : "--"
    }
    
    private var rrText: String {
        guard let latest = bluetooth.rrIntervals.last else { return "-- ms"}
        return "\(Int(latest)) ms"
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Hey, \(profile?.username ?? "Runner")")
                .font(.screenTitle)
                .foregroundStyle(Color.primaryText)
        }
    }
}

/// Pill with colored dot showing Bluetooth status
private struct ConnectionPill: View {
    
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: Spacing.small) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(Color.primaryText)
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.small)
        .background(Color.card)
        .clipShape(Capsule())
    }
}

#Preview {
    HomeView()
}
