//
//  Color.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 16.11.26.
//

import SwiftUI

/// Color Palette
enum ColorPalette {

    // Deep Blue Sea Color Palette
    static let navy900: Color = Color(hex: 0x0b132b)
    static let navy800: Color = Color(hex: 0x1c2541)
    static let navy600: Color = Color(hex: 0x3a506b)
    
    static let teal: Color = Color(hex: 0x5bc0be)
    static let cyan: Color = Color(hex: 0x6fffe9)
    
    // Tropical Current Color Palette
    static let blue: Color = Color(hex: 0x0081cf)
    static let green: Color = Color(hex: 0x00c9a7)
    static let yellow: Color = Color(hex: 0xffc75f)
    static let orange: Color = Color(hex: 0xff9671)
    static let pink: Color = Color(hex: 0xff6f91)
    
    // Neutrals
    static let white: Color = Color.white
    static let grey: Color = Color.white.opacity(0.65)
}
