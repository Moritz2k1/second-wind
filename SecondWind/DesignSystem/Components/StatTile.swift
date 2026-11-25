//
//  StatTile.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 25.11.26.
//

import SwiftUI

struct StatTile: View {
    
    let title: String
    let value: String
    var unit: String? = nil
    let systemImage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Label(title, systemImage: systemImage)
                .font(.caption)
                .foregroundStyle(ColorToken.metricLabel)
            
            HStack(alignment: .firstTextBaseline, spacing: Spacing.small / 2) {
                Text(value)
                    .font(.statValue)
                    .foregroundStyle(ColorToken.metricValue)
                
                if let unit {
                    Text(unit)
                        .font(.subheadline)
                        .foregroundStyle(ColorToken.metricUnit)
                }
            }
        }
        .cardStyle()
    }
}

#Preview {
    HStack {
        StatTile(title: "Distance", value: "42.5", unit: "km", systemImage: "map")
        StatTile(title: "Runs", value: "9", systemImage: "figure.run")
    }
    .padding()
    .screenBackground()
}
