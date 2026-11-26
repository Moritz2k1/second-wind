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
    
    /// e.g. "12:34" or "1:02:05" for live timer
    static func clock(_ seconds: TimeInterval) -> String {
        let pattern: Duration.TimeFormatStyle.Pattern = seconds >= 3600 ? .hourMinuteSecond : .minuteSecond
        return Duration.seconds(seconds).formatted(.time(pattern: pattern))
    }
    
    /// e.g. "6.2" - 1 decimal
    static func distance(_ km: Double) -> String {
        km.formatted(.number.precision(.fractionLength(1)))
    }
    
    /// e.g. "80 %"
    static func percent(_ ratio: Double) -> String {
        ratio.formatted(.percent.precision(.fractionLength(0)))
    }
    
    /// e.g. "6:10"
    static func pace(_ secondsPerKm: TimeInterval?) -> String {
        guard let secondsPerKm else { return "-- : --" }
        return Duration.seconds(secondsPerKm).formatted(.time(pattern: .minuteSecond))
    }
}
