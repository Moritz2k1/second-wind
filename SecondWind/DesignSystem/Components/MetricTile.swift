//
//  MetricTile.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 17.11.26.
//

import SwiftUI

/// Card with label and big number
struct MetricTile: View {
    
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text(title)
                .font(.caption)
                .foregroundStyle(ColorToken.metricLabel)
            
            HStack(alignment: .firstTextBaseline, spacing: Spacing.small) {
                Text(value)
                    .font(.metric)
                    .foregroundStyle(ColorToken.metricValue)
                    // Never wrap a number, shrink it instead
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Text(unit)
                    .font(.body)
                    .foregroundStyle(ColorToken.metricUnit)
                    // Unit keeps its size, number gets the remaining space
                    .fixedSize()
            }
        }
        .cardStyle()
    }
}
