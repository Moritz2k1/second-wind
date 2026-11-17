//
//  Color.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 16.11.26.
//

import SwiftUI

/*
 Deep Blue Sea Color Palette
 Background: 0b132b - Very dark navy
 Cards: 1c2541 - Dark navy
 Secondary Cards: 3a506b - Navy
 Secondary accent: 5bc0be - Teal
 Accent: 6fffe9 - Cyan
 */
extension Color {
    
    /// Create color from hex value
    init (hex: UInt32) {
        let red: Double = Double((hex >> 16) & 0xFF) / 255
        let green: Double = Double((hex >> 8) & 0xFF) / 255
        let blue: Double = Double(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
    
    // Brand
    static let accent: Color = Color(hex: 0x6fffe9)
    static let secondaryAccent: Color = Color(hex: 0x5bc0be)
    
    // Backgrounds
    static let bg: Color = Color(hex: 0x0b132b)
    static let card: Color = Color(hex: 0x1c2541)
    static let cardSecondary: Color = Color(hex: 0x3a506b)
    
    // Text Colors
    static let primaryText: Color = Color.white
    static let secondaryText: Color = Color.white.opacity(0.65)
    
    // Zone colors
    static let zone1: Color = Color(hex: 0x0081cf)
    static let zone2: Color = Color(hex: 0x00c9a7)
    static let zone3: Color = Color(hex: 0xffc75f)
    static let zone4: Color = Color(hex: 0xff9671)
    static let zone5: Color = Color(hex: 0xff6f91)
    
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
