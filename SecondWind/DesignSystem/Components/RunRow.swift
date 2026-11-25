//
//  RunRow.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 25.11.26.
//

import SwiftUI

/// Card with summary of one past run
struct RunRow: View {
    
    let run: Run
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            HStack(spacing: Spacing.medium) {
                icon
                titles
            }
            
            details
            zoneSection
        }
        .cardStyle()
    }
    
    private var icon: some View {
        Image(systemName: run.type.systemImage)
            .font(.title3)
            .foregroundStyle(ColorToken.iconForeground)
            .frame(width: 44, height: 44)
            .background(ColorToken.iconBackground)
            .clipShape(RoundedRectangle(cornerRadius: Radius.button))
    }
    
    private var titles: some View {
        VStack(alignment: .leading, spacing: Spacing.small / 2) {
            Text(run.type.title)
                .font(.headline)
                .foregroundStyle(ColorToken.primaryText)
            
            // e.g. Mon, 23 Nov, 14:06
            Text(run.startDate.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated).hour().minute()))
                .font(.subheadline)
                .foregroundStyle(ColorToken.secondaryText)
            
        }
    }
    
    private var details: some View {
        HStack(spacing: Spacing.large) {
            Label(RunFormat.duration(run.duration), systemImage: "clock")
            Label("~ \(RunFormat.distance(run.distanceKm)) km", systemImage: "map")
        }
        .font(.subheadline.monospacedDigit())
        .foregroundStyle(ColorToken.primaryText)
    }
    
    @ViewBuilder
    private var zoneSection: some View {
        if let zone = run.targetZone {
            VStack(alignment: .leading, spacing: Spacing.small) {
                HStack {
                    ZoneBadge(zone: zone)
                    
                    Spacer()
                    
                    Text("\(RunFormat.percent(run.timeInZoneRatio)) in zone")
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(ColorToken.primaryText)
                }
                
                ZoneProgressBar(
                    value: run.timeInZoneRatio,
                    color: Color.zoneColor(zoneId: zone.id)
                )
            }
        }
    }
}

#Preview {
    RunRow(run: Run.samples[0])
        .padding()
        .screenBackground()
}
