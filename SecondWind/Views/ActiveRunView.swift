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
    
    
}
