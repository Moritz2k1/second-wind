//
//  Colors.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 16.11.26.
//

import SwiftUI

/*
 Deep Blue Sea Color Palette
 Background: 0b132b
 Surface / Cards: 1c2541
 Secondary Surface / Cards: 3a506b
 Secondary accent: 5bc0be
 Accent: 6fffe9
 */
extension Color {
    
    /// Create color from hex value
    init (hex: UInt32) {
        let red: Double = Double((hex >> 16) & 0xFF) / 255
        let green: Double = Double((hex >> 8) & 0xFF) / 255
        let blue: Double = Double(hex >> 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}
