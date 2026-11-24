//
//  Statistics.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 24.11.26.
//

import Foundation

/// Distance of all runs in one calendar week
struct WeeklyDistance: Identifiable {
    let weekStart: Date
    let distanceKm: Double
    
    var id: Date { weekStart }
}

/// Totals calculated from a list of runs
struct Statistics {
    
    let runCount: Int
    let totalDistanceKm: Double
    let totalDuration: TimeInterval
    
    // All running time spent in target zone
    let timeInZoneRatio: Double
}
