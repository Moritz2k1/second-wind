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
            ColorToken.screenBackground
            EllipticalGradient(
                colors: [ColorToken.screenGlow, .clear],
                center: .top,
                startRadiusFraction: 0,
                endRadiusFraction: 0.8
            )
        }
        .ignoresSafeArea()
    }
}

extension View {
    /// Fills available space and puts ScreenBackground behind view
    func screenBackground() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background { ScreenBackground() }
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ScreenBackground()
}
