//
//  ZoneBadge.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 17.11.26.
//

import SwiftUI

/// Pill showing training zone
struct ZoneBadge: View {
    
    let zone: TrainingZone
    
    var body: some View {
        let color: Color = Color.zoneColor(zoneId: zone.id)
        
        HStack(spacing: Spacing.small) {
            Text(zone.name)
                .bold()
            Text(zone.title)
        }
        .font(.subheadline)
        .foregroundStyle(color)
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.small)
        .background(color.opacity(0.2))
        .clipShape(Capsule())
    }
}
