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
    let title: String
    let minPercent: Double
    
    // Define zones (Type property shared by all instances)
    static let zones: [TrainingZone] = [
        
        // Zone 1
        TrainingZone(
            id: 1,
            name: "Zone 1",
            title: "Recovery",
            minPercent: 0.6
        ),
        
        // Zone 2
        TrainingZone(
            id: 2,
            name: "Zone 2",
            title: "Endurance",
            minPercent: 0.72
        ),
        
        // Zone 3
        TrainingZone(
            id: 3,
            name: "Zone 3",
            title: "Aerobic",
            minPercent: 0.82
        ),
        
        // Zone 4
        TrainingZone(
            id: 4,
            name: "Zone 4",
            title: "Threshold",
            minPercent: 0.87
        ),
        
        // Zone 5
        TrainingZone(
            id: 5,
            name: "Zone 5",
            title: "Maximum",
            minPercent: 0.92
        ),
    ]
    
    /// True for highest zone, which has no zone above it
    private var isLastZone: Bool {
        return id == TrainingZone.zones.count
    }
    
    /// Tells where zone ends and next one starts in %
    var maxPercent: Double {
        
        // Already in last training zone
        if isLastZone {
            return 1.0
        }
        
        return TrainingZone.zones[id].minPercent
    }
    
    /// Converts zone starting percentage into bpm
    func calcMinHR(userMaxHR: Int) -> Int {
        let val = Double(userMaxHR) * minPercent
        return Int(val.rounded())
    }
    
    /// Calculate highest heart rate that still belongs to zone
    func calcMaxHR(userMaxHR: Int) -> Int {
        
        // Already in zone 5
        if isLastZone {
            return userMaxHR
        }
        
        let nextZone = TrainingZone.zones[id]
        
        // -1 ensures that two consecutive heart rate zones don't overlap
        return nextZone.calcMinHR(userMaxHR: userMaxHR) - 1
    }
    
    /// Checks if heart rate is in zone
    func containsHR(HR: Int, maxHR: Int) -> Bool {
        let lowest = calcMinHR(userMaxHR: maxHR)
        let highest = calcMaxHR(userMaxHR: maxHR)
        
        if isLastZone {
            return HR >= lowest
        }
        
        return HR >= lowest && HR <= highest
    }
    
    /// Check in which zone heart rate is in
    static func zone(HR: Int, maxHR: Int) -> TrainingZone? {
        
        // Iterate and check if zone contains HR
        for zone in zones {
            if zone.containsHR(HR: HR, maxHR: maxHR) {
                return zone
            }
        }
        
        return nil
    }
}
