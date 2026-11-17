//
//  PreviewContent.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 17.11.26.
//

import SwiftUI

private struct PreviewContent: View {

    var body: some View {
        VStack(spacing: Spacing.large) {

            // Header
            VStack(spacing: Spacing.small) {
                Text("Training")
                    .font(.screenTitle)
                    .foregroundStyle(Color.primaryText)

                Text("Easy run · 32 min")
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryText)

                ZoneBadge(zone: TrainingZone.zones[1])
                    .padding(.top, Spacing.small)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, Spacing.large)

            // Main metric
            MetricTile(title: "Heart rate", value: "142", unit: "bpm")

            // Secondary metrics
            Grid(horizontalSpacing: Spacing.medium, verticalSpacing: Spacing.medium) {
                GridRow {
                    MetricTile(title: "Distance", value: "5.2", unit: "km")
                    MetricTile(title: "Pace", value: "6:10", unit: "/km")
                }
            }

            Spacer()

            // Actions
            VStack(spacing: Spacing.medium) {
                Button("Pause") { }
                    .buttonStyle(.primary)

                Button("End workout") { }
                    .buttonStyle(.secondary)
            }
        }
        .padding(.horizontal, Spacing.large)
        .padding(.bottom, Spacing.medium)
    }
}

#Preview {
    PreviewContent()
        .background { ScreenBackground() }
        .preferredColorScheme(.dark)
}
