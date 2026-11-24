//
//  RunFormat.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 24.11.26.
//

import Foundation

/// Shared text formats for run values
enum RunFormat {
    /// e.g. "45m" or "1h 15m"
    static func duration(_ seconds: TimeInterval) -> String {
        Duration.seconds(seconds).formatted(.units(allowed: [.hours, .minutes], width: .narrow))
    }
    
    /// e.g. "6.2" - 1 decimal
    static func distance(_ km: Double) -> String {
        km.formatted(.number.precision(.fractionLength(1)))
    }
    
    /// e.g. "80 %"
    static func percent(_ ratio: Double) -> String {
        ratio.formatted(.percent.precision(.fractionLength(0)))
    }
}
