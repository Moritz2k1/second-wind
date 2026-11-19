//
//  ColorToken.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 19.11.26.
//

import SwiftUI

// Alias so it easiert to differentiate
typealias ColorToken = Color

/// Semantic Tokens
extension Color {
    
    // Brand
    static let accent: Color = ColorPalette.cyan
    static let secondaryAccent: Color = ColorPalette.teal
    
    // Backgrounds
    static let bg: Color = ColorPalette.navy900
    
    // Text Colors
    static let primaryText: Color = ColorPalette.white
    static let secondaryText: Color = ColorPalette.grey
    static let onAccent: Color = ColorPalette.navy900
    
    // Cards
    static let cardBackground: Color = ColorPalette.navy800
    static let cardBorder: Color = ColorPalette.white.opacity(0.08)
    
    // Pills
    static let pillBackground: Color = ColorPalette.navy800
    
    // Icons
    static let iconBackground: Color = ColorPalette.navy600.opacity(0.6)
    static let heartIcon: Color = ColorPalette.pink
    
    // Charts
    static let chartLine: Color = ColorPalette.cyan
    
    // Connection colors
    static let connected: Color = ColorPalette.green
    static let scanning: Color = ColorPalette.yellow
    static let disconnected: Color = ColorPalette.grey
    
    // Zone colors
    static let zone1: Color = ColorPalette.blue
    static let zone2: Color = ColorPalette.green
    static let zone3: Color = ColorPalette.yellow
    static let zone4: Color = ColorPalette.orange
    static let zone5: Color = ColorPalette.pink
    
    /// Returns color for zone id
    static func zoneColor(zoneId: Int) -> Color {
        switch zoneId {
        case 1: return zone1
        case 2: return zone2
        case 3: return zone3
        case 4: return zone4
        case 5: return zone5
        default: return Color.indigo
        }
    }
}

