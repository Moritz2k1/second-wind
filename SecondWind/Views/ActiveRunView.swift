//
//  ActiveRunView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import SwiftUI
import SwiftData

/// Full screen during run
struct ActiveRunView: View {
    
    // Same run as on Home
    let runViewModel: RunViewModel
    
    // Database for saving finished run
    @Environment(\.modelContext) private var modelContext
    
    // Asks before ending, prevents accidental taps
    @State private var showsEndConfirmation: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.large) {
                header
                heartRateSection
                statsRow
                distanceRow
                zoneProgress
            }
            .padding(.horizontal, Spacing.large)
            .padding(.top, Spacing.large)
        }
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            controls
                .padding(Spacing.large)
        }
        .screenBackground()
        
        // Asks before ending, shown from bottom
        .confirmationDialog("End run?", isPresented: $showsEndConfirmation, titleVisibility: .visible) {
            Button("End and save") {
                runViewModel.end(saveTo: modelContext)
            }
            
            Button("Keep running", role: .cancel) { }
        } message: {
            Text("Runs shorter than \(RunFormat.duration(Configuration.minimumRunDuration)) are not saved")
        }
    }
    
    private var header: some View {
        ScreenHeader(
            title: runViewModel.runType.title,
            subtitle: runViewModel.state == .paused ? "Paused" : nil
        ) {
            if let zone = runViewModel.targetZone {
                ZoneBadge(zone: zone)
            }
        }
    }
    
    private var heartRateSection: some View {
        VStack(spacing: Spacing.small) {
            MetricTile(title: "Heart rate", value: heartRateText, unit: "bpm")
            zoneStatus
        }
    }
    
    private var heartRateText: String {
        runViewModel.heartRate > 0 ? "\(runViewModel.heartRate)" : "--"
    }
    
    // Shows at a glance if user is in target zone
    private var zoneStatus: some View {
        let isInZone: Bool = runViewModel.isInTargetZone
        
        return Label(
            isInZone ? "In target zone" : "Outside target zone",
            systemImage: isInZone ? "checkmark.circle.fill" : "exclamationmark.circle"
        )
        .font(.subheadline)
        .foregroundStyle(isInZone ? ColorToken.zoneStatusInside : ColorToken.zoneStatusOutside)
    }
    
    private var statsRow: some View {
        HStack(spacing: Spacing.medium) {
            StatTile(
                title: "Time",
                value: RunFormat.clock(runViewModel.elapsed),
                systemImage: "clock"
            )
            
            StatTile(
                title: "In zone",
                value: RunFormat.percent(runViewModel.timeInZoneRatio),
                systemImage: "target"
            )
        }
    }
    
    // Distance so far and pace of last seconds
    private var distanceRow: some View {
        HStack(spacing: Spacing.medium) {
            StatTile(
                title: "Distance",
                value: "≈ \(RunFormat.distance(runViewModel.distanceKm))",
                unit: "km",
                systemImage: "map"
            )
            
            StatTile(
                title: "Pace",
                value: RunFormat.pace(runViewModel.currentPaceSecondsPerKm),
                unit: "/km",
                systemImage: "speedometer"
            )
        }
    }
    
    private var controls: some View {
        VStack(spacing: Spacing.medium) {
            if runViewModel.state == .paused {
                Button("Resume") { runViewModel.resume() }
                    .buttonStyle(.primary)
            } else {
                Button("Pause") { runViewModel.pause() }
                    .buttonStyle(.primary)
            }
            
            Button("End run") { showsEndConfirmation = true }
                .buttonStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private var zoneProgress: some View {
        if let zone = runViewModel.targetZone {
            ZoneProgressBar(
                value: runViewModel.timeInZoneRatio,
                color: Color.zoneColor(zoneId: zone.id)
            )
        }
    }
}

#Preview {
    ActiveRunView(runViewModel: RunViewModel())
        .modelContainer(for: Run.self, inMemory: true)
}
