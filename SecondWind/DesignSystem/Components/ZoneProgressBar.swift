//
//  ZoneProgressBar.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 25.11.26.
//

import SwiftUI

/// Shows how much of a run was spent in a zone
struct ZoneProgressBar: View {
    
    // Share between 0 and 1
    let value: Double
    let color: Color
    
    var body: some View {
        // Empty track
        Capsule()
            .fill(ColorToken.progressTrack)
            .frame(height: 8)
            .overlay(alignment: .leading) {
                GeometryReader { proxy in
                Capsule()
                    .fill(color)
                    .frame(width: proxy.size.width * clamp)
                }
            }
    }
    
    /// Keeps bar inside track
    private var clamp: Double {
        min(max(value, 0), 1)
    }
}

#Preview {
    VStack(spacing: Spacing.medium) {
        ZoneProgressBar(value: 0.82, color: ColorToken.zone2)
        ZoneProgressBar(value: 0.4, color: ColorToken.zone3)
    }
    .padding()
    .screenBackground()
}
