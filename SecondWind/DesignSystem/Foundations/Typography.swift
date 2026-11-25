//
//  Typography.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 16.11.26.
//

import SwiftUI

extension Font {
    
    /// Screen titles
    static let screenTitle: Font = Font.largeTitle.bold()
    
    /// Section titles
    static let sectionTitle: Font = Font.title2.bold()
    
    /// Big numbers on training screen
    static let metric: Font = Font
        .system(size: 72, weight: .bold, design: .rounded)
        .monospacedDigit()
    
    // Numbers in small stat tiles
    static let statValue: Font = Font
        .system(.title2, design: .rounded, weight: .bold)
        .monospacedDigit()
}
