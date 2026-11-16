//
//  Buttons.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 16.11.26.
//

import SwiftUI

/// Main button - filled cyan
struct PrimaryButtonStyle: ButtonStyle {
    
    // Greyed out when button is disabled
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(Color.background)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.medium)
            .background(Color.accent.opacity(isEnabled ? 1.0 : 0.35))
            .clipShape(RoundedRectangle(cornerRadius: Radius.button))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
