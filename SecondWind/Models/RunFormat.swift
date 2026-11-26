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
    
    /// e.g. "30 sec" or "2 min",
    static func setting(_ seconds: TimeInterval) -> String {
        guard seconds > 0 else { return "Off" }
        return Duration.seconds(seconds).formatted(.units(allowed: [.minutes, .seconds], width: .abbreviated))
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
    
    /// e.g. "139–156 bpm" for zone and user's max heart rate
    static func heartRateRange(of zone: TrainingZone, maxHeartRate: Int) -> String {
        let lowest: Int = zone.calcMinHR(userMaxHR: maxHeartRate)
        let highest: Int = zone.calcMaxHR(userMaxHR: maxHeartRate)
        return "\(lowest)–\(highest) bpm"
    }
}
