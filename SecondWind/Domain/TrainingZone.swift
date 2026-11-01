//
//  TrainingZone.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 01.11.26.
//

import Foundation

struct TrainingZone: Identifiable {
    
    // Properties (let = immutable)
    let id: Int
    let name: String
    let description: String
    let minPercent: Double
    
    // Define zones
    static let zones: [TrainingZone] = [
        
        // Zone 1
        TrainingZone(
            id: 1,
            name: "Zone 1",
            description: "Recovery",
            minPercent: 0.6
        ),
        
        // Zone 2
        TrainingZone(
            id: 2,
            name: "Zone 2",
            description: "Endurance",
            minPercent: 0.72
        ),
        
        // Zone 3
        TrainingZone(
            id: 3,
            name: "Zone 3",
            description: "Aerobic",
            minPercent: 0.82
        ),
        
        // Zone 4
        TrainingZone(
            id: 4,
            name: "Zone 4",
            description: "Threshold",
            minPercent: 0.87
        ),
        
        // Zone 5
        TrainingZone(
            id: 5,
            name: "Zone 5",
            description: "Maximum",
            minPercent: 0.92
        ),
    ]
    
    // Tells where zone ends and next one starts in %
    var maxPercent: Double {
        
        // Already in last training zone
        if id == 5 {
            return 1.0
        }
        
        return TrainingZone.zones[id].minPercent
    }
}
