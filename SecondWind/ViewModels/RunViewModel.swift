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
    
    // When run was started
    private(set) var startDate: Date? = nil
    
    // Run time without pauses
    private(set) var elapsed: TimeInterval = 0
    
    // Time collected before last pause
    private var accumulated: TimeInterval = 0
    
    // Start of current active part
    private var activeSince: Date? = nil
    
    // Updates elapsed every second
    private var timerTask: Task<Void , Never>? = nil
    
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
        
        // Fresh values for new run
        startDate = .now
        accumulated = 0
        elapsed = 0
        activeSince = .now
        
        state = .active
        startTimer()
    }
    
    /// Pauses run
    func pause() {
        guard state == .active else { return }
        
        // Keep time run so far
        updateElapsed()
        accumulated = elapsed
        activeSince = nil
        
        state = .paused
        stopTimer()
    }
    
    /// Continues paused run
    func resume() {
        guard state == .paused else { return }
        
        // New active part starts now
        activeSince = .now
        state = .active
        startTimer()
    }
    
    /// Finishes run
    func end() {
        guard state != .idle else { return }
        
        // Last update
        updateElapsed()
        activeSince = nil
        
        state = .idle
        stopTimer()
    }
    
    static func clock(_ seconds: TimeInterval) -> String {
        let pattern: Duration.TimeFormatStyle.Pattern = seconds >= 3600 ? .hourMinuteSecond : .minuteSecond
        return Duration.seconds(seconds).formatted(.time(pattern: pattern))
    }
    
    /// Calls tick every second until stopped
    private func startTimer() {
        timerTask?.cancel()
        
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                self?.tick()
            }
        }
    }
    
    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }
    
    /// Runs every second while active
    private func tick() {
        updateElapsed()
    }
    
    /// Run time = time before pause + time since resume
    private func updateElapsed() {
        guard let activeSince else { return }
        elapsed = accumulated + Date.now.timeIntervalSince(activeSince)
    }
}
