//
//  SecondaryButtonStyle.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 17.11.26.
//

import SwiftUI

/// Secondary Button - cyan outline
struct SecondaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(Color.accent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.button)
                    .stroke(Color.accent, lineWidth: 1.5)
            )
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}

// Can be referenced with .secondary
extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle { SecondaryButtonStyle() }
}
