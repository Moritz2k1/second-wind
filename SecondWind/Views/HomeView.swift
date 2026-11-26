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
    
    // Shared profile - updates when changed in Profile tab
    @Environment(ProfileStore.self) private var profileStore
    
    private var profile: UserProfile? { profileStore.profile }
    
    // Shared connection, owned by MainTabView
    @EnvironmentObject private var bluetooth: CoreBluetoothService
    
    // Setup and state of next or current run
    @State private var runViewModel: RunViewModel = RunViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.large) {
                header
                heartRateCard
                
                if showsRunSetup {
                    runSetupCard
                }
                
                rrCard
            }
            .padding(.horizontal, Spacing.large)
            .padding(.top, Spacing.large)
        }
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            bottomButtons
                .padding(Spacing.large)
        }
        .screenBackground()
        .onAppear {
            bluetooth.onHeartRate = { heartRate in
                runViewModel.update(heartRate: heartRate)
            }
        }
        
        // Run screen covers tabs while running
        .fullScreenCover(isPresented: runScreenBinding) {
            ActiveRunView(runViewModel: runViewModel)
        }
    }
    
    // Setup only makes sense with strap connected and no run going on
    private var showsRunSetup: Bool {
        bluetooth.isConnected && runViewModel.state == .idle
    }
    
    // Opens when run starts, closes when it ends
    private var runScreenBinding: Binding<Bool> {
        Binding(
            get: { runViewModel.isRunning },
            set: { _ in }
        )
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
        ScreenHeader(
            title: "Hey, \(profile?.username ?? "Runner")",
            alignment: .leading
        ) {
            ConnectionPill(
                text: bluetooth.statusText,
                isConnected: bluetooth.isConnected,
                isScanning: bluetooth.isScanning
            )
        }
    }
    
    private var heartRateCard: some View {
        VStack(spacing: Spacing.medium) {
            HStack(alignment: .firstTextBaseline, spacing: Spacing.small) {
                Image(systemName: "heart.fill")
                    .font(.title)
                    .foregroundStyle(ColorToken.heartIcon)
                    .symbolEffect(.pulse, options: .repeating, isActive: bluetooth.heartRate > 0)
                
                Text(heartRateText)
                    .font(.metric)
                    .foregroundStyle(ColorToken.metricValue)
                    .contentTransition(.numericText())
                    .animation(.default, value: bluetooth.heartRate)
                
                Text("bpm")
                    .font(.body)
                    .foregroundStyle(ColorToken.metricUnit)
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
        .foregroundStyle(ColorToken.chartLine)
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
                    .foregroundStyle(ColorToken.primaryText)
                
                Spacer()
                
                Text(rrText)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(ColorToken.chartValue)
            }
            
            if bluetooth.rrHistory.isEmpty {
                Text("Connect your chest strap to see the time between heartbeats")
                    .font(.subheadline)
                    .foregroundStyle(ColorToken.secondaryText)
            }
            else {
                rrChart
            }
        }
        .cardStyle()
    }
    
    private var runSetupCard: some View {
        VStack(alignment: .leading, spacing: Spacing.large) {
            Text("New run")
                .font(.headline)
                .foregroundStyle(ColorToken.primaryText)
            
            runTypePicker
            zonePicker
        }
        .cardStyle()
    }
    
    private var runTypePicker: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Where")
                .font(.subheadline)
                .foregroundStyle(ColorToken.secondaryText)
            
            Picker("Run type", selection: $runViewModel.runType) {
                ForEach(RunType.allCases, id: \.self) { type in
                    Text(type.shortTitle)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    private var zonePicker: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text("Target zone")
                .font(.subheadline)
                .foregroundStyle(ColorToken.secondaryText)
            
            // Tag is zone id, same type as targetZoneId
            Picker("Target zone", selection: $runViewModel.targetZoneId) {
                ForEach(TrainingZone.zones) { zone in
                    Text("\(zone.id)")
                        .tag(zone.id)
                }
            }
            .pickerStyle(.segmented)
            
            // Name and bpm range of selected zone
            if let zone = runViewModel.targetZone {
                HStack {
                    ZoneBadge(zone: zone)
                    
                    Spacer()
                    
                    Text(zoneRangeText(zone))
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(ColorToken.secondaryText)
                }
            }
        }
    }
    
    /// e.g. "139–156 bpm", empty without profile
    private func zoneRangeText(_ zone: TrainingZone) -> String {
        guard let profile else { return "" }
        return RunFormat.heartRateRange(of: zone, maxHeartRate: profile.maxHeartRate)
    }
    
    @ViewBuilder
    private var bottomButtons: some View {
        if bluetooth.isConnected {
            VStack(spacing: Spacing.medium) {
                if runViewModel.state == .idle {
                    Button("Start run") {
                        runViewModel.start(
                            maxHeartRate: profileStore.maxHeartRate,
                            feedbackSettings: FeedbackSettings.load()
                        )
                    }
                        .buttonStyle(.primary)
                }
                
                Button("Disconnect") { bluetooth.disconnect() }
                    .buttonStyle(.secondary)
            }
        } else if bluetooth.isScanning {
            Button("Stop searching") { bluetooth.stopScanning() }
                .buttonStyle(.secondary)
        } else {
            Button("Connect Polar H10") { bluetooth.startScanning() }
                .buttonStyle(.primary)
        }
    }
}

#Preview {
    HomeView()
        .environment(ProfileStore())
        .environmentObject(CoreBluetoothService())
}
