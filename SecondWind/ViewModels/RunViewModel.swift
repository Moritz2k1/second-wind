//
//  RunViewModel.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 25.11.26.
//

import Foundation
import Observation

/// Phase of current run
enum RunState {
    case idle
    case active
    case paused
}

@Observable
class RunViewModel {
    
    // Choices before start
    var runType: RunType = .outdoor
    var targetZoneId: Int = 2
    
    // Only changed by start, pause, resume and end
    private(set) var state: RunState = .idle
    
    /// Zone matching selected id
    var targetZone: TrainingZone? {
        for zone in TrainingZone.zones {
            if zone.id == targetZoneId {
                return zone
            }
        }
        
        return nil
    }
    
    /// Starts new run with selected type and zone
    func start() {
        guard state == .idle else { return }
        state = .active
    }
    
    /// Pauses run
    func pause() {
        guard state == .active else { return }
        state = .paused
    }
    
    /// Continues paused run
    func resume() {
        guard state == .paused else { return }
        state = .active
    }
    
    /// Finishes run
    func end() {
        guard state != .idle else { return }
        state = .idle
    }
}
