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
    
    init(runs: [Run]) {
        var distance: Double = 0
        var duration: TimeInterval = 0
        var timeInZone: TimeInterval = 0
        
        // Add up values of all runs
        for run in runs {
            distance += run.distanceKm
            duration += run.duration
            timeInZone += run.timeInTargetZone
        }
        
        runCount = runs.count
        totalDistanceKm = distance
        totalDuration = duration
        
        // Weighted by duration, long runs count more than short ones
        if duration > 0 {
            timeInZoneRatio = min(timeInZone / duration, 1)
        } else {
            timeInZoneRatio = 0
        }
    }
    
    /// Distance per week for the last weeks
    static func weeklyDistance(
        of runs: [Run],
        // How many bars chart shows
        weeks: Int = 6,
        now: Date = .now,
        // Decides if week starts on Monday or Sunday
        calendar: Calendar = .current
    ) -> [WeeklyDistance] {
        
        // Start and end of current week
        guard let currentWeek: DateInterval = calendar.dateInterval(of: .weekOfYear, for: now) else {
            return []
        }
        
        var result: [WeeklyDistance] = []
        
        // Count down - oldest week comes first
        for offset in stride(from: weeks - 1, through: 0, by: -1) {
            
            // Go back offset weeks from current week
            guard let date: Date = calendar.date(byAdding: .weekOfYear, value: -offset, to: currentWeek.start),
                  // Full week around that date
                    let week: DateInterval = calendar.dateInterval(of: .weekOfYear, for: date)
            else { continue }
            
            // Add up all runs this week
            let distance: Double = distance(of: runs, in: week)
            
            // One bar in chart
            result.append(WeeklyDistance(weekStart: week.start, distanceKm: distance))
        }
        return result
    }
    
    /// Sum of distance of all runs inside week
    private static func distance(of runs: [Run], in week: DateInterval) -> Double {
        var sum: Double = 0
        
        for run in runs {
            
            // End is excluded - already start of next week
            if run.startDate >= week.start && run.startDate < week.end {
                sum += run.distanceKm
            }
        }
        
        return sum
    }
}
