//
//  ScreenHeader.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 20.11.26.
//

import SwiftUI

/// How header lines up on screen
enum HeaderAlignment {
    case center
    case leading
}

/// Title, optional icon and subtitle at the top of screen
struct ScreenHeader<Accessory: View>: View {
    
    let title: String
    var subtitle: String? = nil
    var systemImage: String? = nil
    var alignment: HeaderAlignment = .center
    
    @ViewBuilder var accessory: Accessory
    
    var body: some View {
        VStack(alignment: stackAlignment, spacing: Spacing.small) {
            icon
            texts
            accessory
        }
        .multilineTextAlignment(textAlignment)
        .frame(maxWidth: .infinity, alignment: frameAlignment)
    }
    
    @ViewBuilder
    private var icon: some View {
        if let systemImage {
            Image(systemName: systemImage)
                .font(.system(size: 56))
                .foregroundStyle(ColorToken.heartIcon)
        }
    }
    
    @ViewBuilder
    private var texts: some View {
        Text(title)
            .font(.screenTitle)
            .foregroundStyle(ColorToken.headerTitle)
        
        if let subtitle {
            Text(subtitle)
                .font(.body)
                .foregroundStyle(ColorToken.headerSubtitle)
        }
    }
    
    // SwiftUI needs different alignment type in each place
    private var stackAlignment: HorizontalAlignment {
        alignment == .center ? .center : .leading
    }
    
    private var textAlignment: TextAlignment {
        alignment == .center ? .center : .leading
    }
    
    private var frameAlignment: Alignment {
        alignment == .center ? .center : .leading
    }
}

// Header without accessory
extension ScreenHeader where Accessory == EmptyView {
    
    init(
        title: String,
        subtitle: String? = nil,
        systemImage: String? = nil,
        alignment: HeaderAlignment = .center
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            systemImage: systemImage,
            alignment: alignment
        ) {
            EmptyView()
        }
    }
}
