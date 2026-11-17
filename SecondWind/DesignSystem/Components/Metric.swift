//
//  MetricTile.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 17.11.26.
//

import SwiftUI

/// Card with label and big number
struct Metric: View {
    
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text(title)
                .font(.caption)
                .foregroundStyle(Color.secondaryText)
            
            HStack(alignment: .firstTextBaseline, spacing: Spacing.small) {
                Text(value)
                    .font(.metric)
                    .foregroundStyle(Color.primaryText)
                
                Text(unit)
                    .font(.body)
                    .foregroundStyle(Color.secondaryText)
            }
        }
        .cardStyle()
    }
}
