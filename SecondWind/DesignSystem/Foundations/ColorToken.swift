//
//  ColorToken.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 19.11.26.
//

import SwiftUI

extension Color {
    
    /// Create color from hex value
    init (hex: UInt32) {
        let red: Double = Double((hex >> 16) & 0xFF) / 255
        let green: Double = Double((hex >> 8) & 0xFF) / 255
        let blue: Double = Double(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
    
    // Brand
    static let accent: Color = ColorPalette.cyan
    static let secondaryAccent: Color = ColorPalette.teal
    
    // Backgrounds
    static let bg: Color = Color(hex: 0x0b132b)
    static let card: Color = Color(hex: 0x1c2541)
    static let cardSecondary: Color = Color(hex: 0x3a506b)
    
    // Text Colors
    static let primaryText: Color = Color.white
    static let secondaryText: Color = Color.white.opacity(0.65)
    
    // Zone colors
    static let zone1: Color = ColorPalette.blue
    static let zone2: Color = ColorPalette.green
    static let zone3: Color = ColorPalette.yellow
    static let zone4: Color = ColorPalette.orange
    static let zone5: Color = ColorPalette.pink
    
    // Connection colors
    static let scanning: Color = Color(hex: 0xffc75f)
    static let connected: Color = Color(hex: 0x00c9a7)
    
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

