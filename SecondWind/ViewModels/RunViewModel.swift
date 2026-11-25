//
//  RunViewModel.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 25.11.26.
//

import Foundation
import Observation
import SwiftData

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
    
    // Latest heart rate from chest strap
    private(set) var heartRate: Int = 0
    
    // Time spent in target zone
    private(set) var timeInTargetZone: TimeInterval = 0
    
    // Last time zone time was counted
    private var lastZoneCheck: Date? = nil
    
    // Needed for zone boundaries in bpm
    private let maxHeartRate: Int = UserProfile.loadProfile()?.maxHeartRate ?? 0
    
    /// Zone matching selected id
    var targetZone: TrainingZone? {
        for zone in TrainingZone.zones {
            if zone.id == targetZoneId {
                return zone
            }
        }
        
        return nil
    }
    
    /// True if current heart rate is inside target zone
    var isInTargetZone: Bool {
        guard let targetZone, heartRate > 0, maxHeartRate > 0 else { return false }
        return targetZone.containsHR(HR: heartRate, maxHR: maxHeartRate)
    }
    
    /// Share of run in target zone so far
    var timeInZoneRatio: Double {
        guard elapsed > 0 else { return 0 }
        return min(timeInTargetZone / elapsed, 1)
    }
    
    /// Starts new run with selected type and zone
    func start() {
        guard state == .idle else { return }
        
        // Fresh values for new run
        startDate = .now
        accumulated = 0
        elapsed = 0
        activeSince = .now
        timeInTargetZone = 0
        lastZoneCheck = .now
        
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
        lastZoneCheck = nil
        
        state = .paused
        stopTimer()
    }
    
    /// Continues paused run
    func resume() {
        guard state == .paused else { return }
        
        // New active part starts now
        activeSince = .now
        lastZoneCheck = .now
        state = .active
        startTimer()
    }
    
    /// Finishes run
    func end(saveTo context: ModelContext) {
        guard state != .idle else { return }
        
        // Last update
        updateElapsed()
        updateZoneTime()
        lastZoneCheck = nil
        activeSince = nil
        
        state = .idle
        stopTimer()
        
        // Too short runs are dropped
        guard let run = makeRun() else { return }
        
        context.insert(run)
        try? context.save()
    }
    
    /// Called by view whenever strap sends new value
    func update(heartRate: Int) {
        self.heartRate = heartRate
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
    
    /// Stops timer
    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }
    
    /// Runs every second while active
    private func tick() {
        updateElapsed()
        updateZoneTime()
    }
    
    /// Run time = time before pause + time since resume
    private func updateElapsed() {
        guard let activeSince else { return }
        elapsed = accumulated + Date.now.timeIntervalSince(activeSince)
    }
    
    /// Adds time since last check if heart rate was in target zone
    private func updateZoneTime() {
        guard let lastZoneCheck else { return }
        
        let now: Date = .now
        if isInTargetZone {
            timeInTargetZone += now.timeIntervalSince(lastZoneCheck)
        }
        
        self.lastZoneCheck = now
    }
    
    /// Turns current session into run that can be saved
    private func makeRun() -> Run? {
        guard let startDate, elapsed >= Configuration.minimumRunDuration else { return nil }
        
        return Run(
            startDate: startDate,
            duration: elapsed,
            type: runType,
            distanceKm: 0,
            targetZoneId: targetZoneId,
            timeInTargetZone: timeInTargetZone
        )
    }
}
