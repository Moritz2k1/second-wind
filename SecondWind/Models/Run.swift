//
//  Run.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 24.11.26.
//

import Foundation
import SwiftData

/// Where run took place
enum RunType: String, Codable, CaseIterable {
    case outdoor
    case indoor
    
    var title: String {
        switch self {
        case .outdoor: return "Outdoor run"
        case .indoor: return "Indoor run"
        }
    }
    
    // Short label for pickers
    var shortTitle: String {
        switch self {
        case .outdoor: return "Outdoor"
        case .indoor: return "Treadmill"
        }
    }
    
    var systemImage: String {
        switch self {
        case .outdoor: return "figure.run"
        case .indoor: return "figure.run.treadmill"
        }
    }
}

/// Finished run - saved on device
@Model
final class Run {
    
    // Attributes
    var startDate: Date
    var duration: TimeInterval
    var type: RunType
    
    // Approximate / Treadmill runs are estimated
    var distanceKm: Double
    
    // Zone the user picked before run
    var targetZoneId: Int
    var timeInTargetZone: TimeInterval
    
    init(
        startDate: Date,
        duration: TimeInterval,
        type: RunType,
        distanceKm: Double,
        targetZoneId: Int,
        timeInTargetZone: TimeInterval
    ) {
        self.startDate = startDate
        self.duration = duration
        self.type = type
        self.distanceKm = distanceKm
        self.targetZoneId = targetZoneId
        self.timeInTargetZone = timeInTargetZone
    }
    
    /// Zone matching target zone id, nil if id is unknown
    var targetZone: TrainingZone? {
        for zone in TrainingZone.zones {
            if zone.id == targetZoneId {
                return zone
            }
        }

        return nil
    }
    
    /// Share of run spent in target zone
    var timeInZoneRatio: Double {
        guard duration > 0 else { return 0 }
        return min(timeInTargetZone / duration, 1)
    }
    
    /// Average seconds per km
    var paceSecondsPerKm: TimeInterval? {
        guard distanceKm > 0 else { return nil }
        return duration / distanceKm
    }
}
