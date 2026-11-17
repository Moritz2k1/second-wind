//
//  ScreenBackground.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 16.11.26.
//

import SwiftUI

/// Used as background of every screen
struct ScreenBackground: View {
    
    var body: some View {
        
        ZStack {
            Color.bg
            EllipticalGradient(
                colors: [Color.secondaryAccent.opacity(0.25), .clear],
                center: .top,
                startRadiusFraction: 0,
                endRadiusFraction: 0.8
            )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ScreenBackground()
}
