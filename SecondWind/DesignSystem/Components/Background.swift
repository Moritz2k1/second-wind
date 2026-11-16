//
//  AppBackground.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 16.11.26.
//

import SwiftUI

/// Used as background of every screen
struct AppBackground: View {
    
    var body: some View {
        RadialGradient(
            colors: [Color.surface, Color.background],
            center: .center,
            startRadius: 0,
            endRadius: 500)
        .ignoresSafeArea()
    }
}
