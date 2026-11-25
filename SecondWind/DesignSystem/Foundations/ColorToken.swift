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
    
    // App tint
    static let accent: Color = ColorPalette.cyan
    
    // Text
    static let primaryText: Color = ColorPalette.white
    static let secondaryText: Color = ColorPalette.grey
    
    // Screen
    static let screenBackground: Color = ColorPalette.navy900
    static let screenGlow: Color = ColorPalette.teal.opacity(0.25)
    
    // Header
    static let headerIcon: Color = ColorPalette.cyan
    static let headerTitle: Color = ColorPalette.white
    static let headerSubtitle: Color = ColorPalette.grey
    
    // Primary Button
    static let primaryButtonBackground: Color = ColorPalette.cyan
    static let primaryButtonText: Color = ColorPalette.navy900
    
    // Secondary Button
    static let secondaryButtonBackground: Color = ColorPalette.navy800
    static let secondaryButtonText: Color = ColorPalette.cyan
    static let secondaryButtonBorder: Color = ColorPalette.cyan
    
    // Cards
    static let cardBackground: Color = ColorPalette.navy800
    static let cardBorder: Color = ColorPalette.white.opacity(0.08)
    
    // Pills
    static let pillBackground: Color = ColorPalette.navy800
    static let pillText: Color = ColorPalette.white
    
    // Icons
    static let iconBackground: Color = ColorPalette.navy600.opacity(0.6)
    static let iconForeground: Color = ColorPalette.cyan
    
    // Inputs
    static let inputText: Color = ColorPalette.white
    
    // Metrics
    static let metricLabel: Color = ColorPalette.grey
    static let metricValue: Color = ColorPalette.white
    static let metricUnit: Color = ColorPalette.grey
    
    // Heart rate
    static let heartIcon: Color = ColorPalette.pink
    
    // Charts
    static let chartLine: Color = ColorPalette.cyan
    static let chartBar: Color = ColorPalette.cyan
    static let chartValue: Color = ColorPalette.cyan
    static let chartAxis: Color = ColorPalette.grey
    static let chartGrid: Color = ColorPalette.white.opacity(0.08)
    
    // Progress bars
    static let progressTrack: Color = ColorPalette.navy600.opacity(0.6)
    
    // Onboarding hero
    static let heroIcon: Color = ColorPalette.cyan
    static let heroShadow: Color = ColorPalette.cyan.opacity(0.6)
    static let heroRing: Color = ColorPalette.cyan.opacity(0.35)
    static let heroGlowInner: Color = ColorPalette.cyan.opacity(0.12)
    static let heroGlowOuter: Color = ColorPalette.cyan.opacity(0.06)
    
    // Connection colors
    static let connected: Color = ColorPalette.green
    static let scanning: Color = ColorPalette.yellow
    static let disconnected: Color = ColorPalette.grey
    
    // Zone status during run
    static let zoneStatusInside: Color = ColorPalette.green
    static let zoneStatusOutside: Color = ColorPalette.grey
    
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

