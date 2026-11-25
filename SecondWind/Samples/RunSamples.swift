//
//  RunSamples.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 24.11.26.
//

// Only compiled in debug builds
#if DEBUG
import Foundation
import SwiftData

// Sample Data
extension Run {
    
    /// Example runs for previews, spread over the last weeks
    static var samples: [Run] {
        let now: Date = .now
        
        // (days ago, minutes, type, target zone, share in zone)
        let examples: [(Int, Double, RunType, Int, Double)] = [
            (1, 45, .outdoor, 2, 0.82),
            (3, 30, .indoor, 2, 0.91),
            (5, 60, .outdoor, 2, 0.74),
            (9, 35, .indoor, 3, 0.66),
            (12, 75, .outdoor, 2, 0.88),
            (16, 40, .outdoor, 3, 0.58),
            (20, 30, .indoor, 2, 0.95),
            (27, 50, .outdoor, 2, 0.71),
            (34, 45, .indoor, 1, 0.79)
        ]
        
        var runs: [Run] = []
        
        for (daysAgo, minutes, type, zoneId, inZone) in examples {
            let start: Date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: now) ?? now
            let duration: TimeInterval = minutes * 60
                    
            runs.append(Run(
                startDate: start,
                duration: duration,
                type: type,
                // Pace of about 6:00 min/km
                distanceKm: duration / 360,
                targetZoneId: zoneId,
                timeInTargetZone: duration * inZone
            ))
        }
        return runs
    }
}

extension ModelContainer {
    
    /// In-memory container filled with sample runs
    static var preview: ModelContainer {
        do {
            let config: ModelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container: ModelContainer = try ModelContainer(for: Run.self, configurations: config)
            
            for run in Run.samples {
                container.mainContext.insert(run)
            }
            
            return container
        } catch {
            fatalError("Could not create preview container: \(error)")
        }
    }
}

#endif
