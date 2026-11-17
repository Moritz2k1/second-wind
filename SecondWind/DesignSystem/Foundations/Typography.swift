//
//  Typography.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 16.11.26.
//

import SwiftUI

extension Font {
    
    /// Screen titles
    static let _largeTitle: Font = Font.largeTitle.bold()
    
    /// Section titles
    static let _title: Font = Font.title2.bold()
    
    /// Normal text
    static let _body: Font = Font.body
    
    /// Helper texts
    static let _caption: Font = Font.caption
    
    /// Big numbers on training screen
    static let metric: Font = Font
        .system(size: 72, weight: .bold, design: .rounded)
        .monospacedDigit()
}
