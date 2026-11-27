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

/// Distance reported by tracker
private struct DistancePiece {
    let date: Date
    let meters: Double
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
    
    // When strap sent last value
    private var lastHeartRateDate: Date? = nil
    
    // Needed for zone boundaries in bpm
    private var maxHeartRate: Int = 0
    
    // Meters run so far, without pauses
    private(set) var distanceMeters: Double = 0
    
    // Pieces of last seconds for current pace
    private var recentPieces: [DistancePiece] = []
    
    // GPS or pedometer - chosen at start
    private var distanceTracker: DistanceTracker? = nil
    
    // Speaks "Faster" or "Slower" when outside target zone
    private let feedback: Feedback = Feedback()
    
    // No feedback before this moment, set on start and resume
    private var feedbackQuietUntil: Date = .distantPast
    
    // Set on start from user settings
    private var isFeedbackEnabled: Bool = true
    
    // Heart rate is logged now and then, not every second
    private var lastHeartRateLog: Date = .distantPast
    
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
    
    /// True while run screen should be shown
    var isRunning: Bool {
        state != .idle
    }
    
    /// Distance in km - for screen and saving
    var distanceKm: Double {
        distanceMeters / 1000
    }
    
    /// Seconds per km since start
    var averagePaceSecondsPerKm: TimeInterval? {
        guard distanceMeters >= Configuration.minimumPaceDistance else { return nil }
        return elapsed / distanceKm
    }
    
    /// Seconds per km over last seconds
    var currentPaceSecondsPerKm: TimeInterval? {
        guard let activeSince else { return nil }
        
        // Only pieces inside window count
        let windowStart: Date = Date.now.addingTimeInterval(-Configuration.paceWindow)
        var meters: Double = 0
        
        for piece in recentPieces {
            if piece.date >= windowStart {
                meters += piece.meters
            }
        }
        
        guard meters >= Configuration.minimumPaceDistance else { return nil }
        
        // Shorter window right after start or resume
        let seconds: TimeInterval = min(Configuration.paceWindow, Date.now.timeIntervalSince(activeSince))
        
        return seconds / (meters / 1000)
    }
    
    /// Starts new run with selected type and zone
    func start(maxHeartRate: Int, feedbackSettings: FeedbackSettings) {
        guard state == .idle else { return }
        
        // Fresh values for new run
        startDate = .now
        self.maxHeartRate = maxHeartRate
        isFeedbackEnabled = feedbackSettings.isEnabled
        feedback.interval = feedbackSettings.interval
        accumulated = 0
        elapsed = 0
        activeSince = .now
        timeInTargetZone = 0
        lastZoneCheck = .now
        lastHeartRateDate = nil
        lastHeartRateLog = .distantPast
        distanceMeters = 0
        recentPieces = []
        
        // Warm up, length chosen in Profile
        feedbackQuietUntil = Date.now.addingTimeInterval(feedbackSettings.warmup)
        
        // Pick tracker for run type, it reports every new piece of distance
        distanceTracker = makeTracker()
        distanceTracker?.onDistanceChange = { [weak self] meters in
            self?.addDistance(meters)
        }
        distanceTracker?.start()
        
        state = .active
        startTimer()
        
        AppLog.shared.add(
            "Run started: \(runType.shortTitle), zone \(targetZoneId), max HR \(maxHeartRate), feedback \(isFeedbackEnabled ? "on" : "off"), every \(RunFormat.setting(feedbackSettings.interval)), quiet at start \(RunFormat.setting(feedbackSettings.warmup))",
            category: .run
        )
    }
    
    /// Pauses run
    func pause() {
        guard state == .active else { return }
        
        // Keep time run so far
        updateElapsed()
        updateZoneTime()
        accumulated = elapsed
        activeSince = nil
        lastZoneCheck = nil
        distanceTracker?.stop()
        recentPieces = []
        feedback.stop()
        state = .paused
        stopTimer()
        
        AppLog.shared.add("Run paused at \(RunFormat.clock(elapsed))", category: .run)
    }
    
    /// Continues paused run
    func resume() {
        guard state == .paused else { return }
        
        // New active part starts now
        activeSince = .now
        lastZoneCheck = .now
        
        // Starts fresh, distance during pause isn't counted
        distanceTracker?.start()
        
        // Short grace period
        let pauseEnd: Date = Date.now.addingTimeInterval(Configuration.feedbackResume)
        feedbackQuietUntil = max(feedbackQuietUntil, pauseEnd)
        
        state = .active
        startTimer()
        
        AppLog.shared.add("Run resumed", category: .run)
    }
    
    /// Finishes run
    func end(saveTo context: ModelContext) {
        guard state != .idle else { return }
        
        // Last update
        updateElapsed()
        updateZoneTime()
        lastZoneCheck = nil
        activeSince = nil
        distanceTracker?.stop()
        distanceTracker = nil
        feedback.stop()
        state = .idle
        stopTimer()
        
        let summary: String = "\(RunFormat.clock(elapsed)), \(RunFormat.distance(distanceKm)) km, \(RunFormat.percent(timeInZoneRatio)) in zone"
        
        // Too short runs are dropped
        guard let run = makeRun() else {
            AppLog.shared.add("Run ended, too short to save: \(summary)", category: .run)
            return
        }
        
        context.insert(run)
        try? context.save()
        AppLog.shared.add("Run ended and saved: \(summary)", category: .run)
    }
    
    /// Called by service whenever strap sends new value
    func update(heartRate: Int) {
        // Count time since last value, with heart rate that was valid in between
        updateZoneTime()
        
        self.heartRate = heartRate
        lastHeartRateDate = .now
        logHeartRateIfDue()
        
        // Only during active run
        if isFeedbackEnabled, state == .active, Date.now >= feedbackQuietUntil, let targetZone, maxHeartRate > 0 {
            feedback.evaluate(currentHR: heartRate, zone: targetZone, userMaxHR: maxHeartRate)
        }
    }
    
    /// Writes heart rate to log every few seconds during run, shows if data arrives while locked
    private func logHeartRateIfDue() {
        guard state == .active, Date.now.timeIntervalSince(lastHeartRateLog) >= Configuration.heartRateLogInterval else { return }
        
        lastHeartRateLog = .now
        
        let quiet: Bool = Date.now < feedbackQuietUntil
        AppLog.shared.add(
            "Heart rate \(heartRate) bpm, \(isInTargetZone ? "in" : "outside") zone\(quiet ? ", feedback still quiet" : "") (\(AppLog.appState))",
            category: .run
        )
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
    
    /// Runs every second while active, only updates screen
    private func tick() {
        updateElapsed()
        clearStaleHeartRate()
    }
    
    /// Shows "--" instead of old value when strap stopped sending
    private func clearStaleHeartRate() {
        guard let lastHeartRateDate else { return }
        
        if Date.now.timeIntervalSince(lastHeartRateDate) > Configuration.heartRateTimeout {
            heartRate = 0
        }
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
        let gap: TimeInterval = now.timeIntervalSince(lastZoneCheck)
        
        // Long gap means no data from strap, heart rate unknown in between
        if isInTargetZone && gap <= Configuration.heartRateTimeout {
            timeInTargetZone += gap
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
            distanceKm: distanceKm,
            targetZoneId: targetZoneId,
            timeInTargetZone: timeInTargetZone
        )
    }
    
    /// Called by tracker with meters moved since last call
    private func addDistance(_ meters: Double) {
        // Pieces arriving during pause don't count
        guard state == .active else { return }
        
        distanceMeters += meters
        recentPieces.append(DistancePiece(date: .now, meters: meters))
        removeOldPieces()
    }
    
    /// Only pieces inside pace window
    private func removeOldPieces() {
        let windowStart: Date = Date.now.addingTimeInterval(-Configuration.paceWindow)
        var kept: [DistancePiece] = []
        
        for piece in recentPieces {
            if piece.date >= windowStart {
                kept.append(piece)
            }
        }
        
        recentPieces = kept
    }
    
    /// GPS outside, step counter on treadmill
    private func makeTracker() -> DistanceTracker {
        switch runType {
        case .outdoor:
            return GPSDistanceTracker()
        case .indoor:
            return PedometerDistanceTracker()
        }
    }
}
