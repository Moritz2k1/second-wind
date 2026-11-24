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
                
                Text(unit)
                    .font(.body)
                    .foregroundStyle(ColorToken.metricUnit)
            }
        }
        .cardStyle()
    }
}
