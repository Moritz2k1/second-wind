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
            Color.background
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
