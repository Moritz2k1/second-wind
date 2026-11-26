//
//  DestructiveButtonStyle.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import SwiftUI

/// Destructive button - pink outline, for actions that can't be undone
struct DestructiveButtonStyle: ButtonStyle {
    
    // Greyed out when button is disabled
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(ColorToken.deleteButtonText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.medium)
            .background(ColorToken.deleteButtonBackground)
            .clipShape(RoundedRectangle(cornerRadius: Radius.button))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.button)
                    .stroke(ColorToken.deleteButtonBorder, lineWidth: 1.5)
            )
            .opacity(isEnabled ? (configuration.isPressed ? 0.6 : 1.0) : 0.35)
    }
}

// Can be referenced with .destructive
extension ButtonStyle where Self == DestructiveButtonStyle {
    static var destructive: DestructiveButtonStyle { DestructiveButtonStyle() }
}
