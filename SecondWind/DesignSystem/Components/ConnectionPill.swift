//
//  ConnectionPill.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import SwiftUI

/// Pill with colored dot showing Bluetooth status
struct ConnectionPill: View {
    
    let text: String
    let isConnected: Bool
    let isScanning: Bool
    
    var body: some View {
        HStack(spacing: Spacing.small) {
            Circle()
                .fill(dotColor)
                .frame(width: 8, height: 8)
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(ColorToken.pillText)
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.small)
        .background(ColorToken.pillBackground)
        .clipShape(Capsule())
    }
    
    // Yellow = searching, green = connected, grey otherwise
    private var dotColor: Color {
        if isScanning { return ColorToken.scanning }
        if isConnected { return ColorToken.connected }
        return ColorToken.disconnected
    }
}
