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
        ScrollView {
            VStack(spacing: Spacing.large) {
                header
                heartRateCard
                rrCard
            }
            .padding(.horizontal, Spacing.large)
            .padding(.top, Spacing.large)
        }
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            connectionButton
                .padding(Spacing.large)
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
    
    private var connectionColor: Color {
        if bluetooth.isScanning { return Color.scanning }
        if bluetooth.isConnected { return Color.connected }
        return Color.secondaryText
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Hey, \(profile?.username ?? "Runner")")
                .font(.screenTitle)
                .foregroundStyle(Color.primaryText)
            
            ConnectionPill(text: bluetooth.statusText, color: connectionColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var heartRateCard: some View {
        VStack(spacing: Spacing.medium) {
            HStack(alignment: .firstTextBaseline, spacing: Spacing.small) {
                Image(systemName: "heart.fill")
                    .font(.title)
                    .foregroundStyle(Color.zone5)
                    .symbolEffect(.pulse, options: .repeating, isActive: bluetooth.heartRate > 0)
                
                Text(heartRateText)
                    .font(.metric)
                    .foregroundStyle(Color.primaryText)
                    .contentTransition(.numericText())
                    .animation(.default, value: bluetooth.heartRate)
                
                Text("bpm")
                    .font(.body)
                    .foregroundStyle(Color.secondaryText)
            }
            
            if let currentZone {
                ZoneBadge(zone: currentZone)
            }
        }
        .frame(maxWidth: .infinity)
        .cardStyle()
    }
    
    private var rrChart: some View {
        Chart(Array(bluetooth.rrHistory.enumerated()), id: \.offset) { sample in
        LineMark(
            x: .value("Beat", sample.offset),
            y: .value("RR", sample.element)
        )
        .interpolationMethod(.catmullRom)
        .foregroundStyle(Color.accent)
        }
        .chartXAxis(.hidden)
        .chartYScale(domain: .automatic(includesZero: false))
        .frame(height: 140)
    }
    
    private var rrCard: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack {
                Text("RR intervals")
                    .font(.headline)
                    .foregroundStyle(Color.primaryText)
                
                Spacer()
                
                Text(rrText)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(Color.accent)
            }
            
            if bluetooth.rrHistory.isEmpty {
                Text("Connect your chest strap to see the time between heartbeats")
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryText)
            }
            else {
                rrChart
            }
        }
        .cardStyle()
    }
    
    @ViewBuilder
        private var connectionButton: some View {
            if bluetooth.isConnected {
                Button("Disconnect") { bluetooth.disconnect() }
                    .buttonStyle(.secondary)
            } else if bluetooth.isScanning {
                Button("Stop searching") { bluetooth.stopScanning() }
                    .buttonStyle(.secondary)
            } else {
                Button("Connect Polar H10") { bluetooth.startScanning() }
                    .buttonStyle(.primary)
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
