//
//  GPSDistanceTracker.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import CoreLocation

/// Measures outdoor distance with GPS
final class GPSDistanceTracker: DistanceTracker {
    
    var onDistanceChange: ((Double) -> Void)? = nil
    
    // Reads new position in a loop
    private var updatesTask: Task<Void, Never>? = nil
    
    // Keeps location running while screen is locked
    private var backgroundSession: CLBackgroundActivitySession? = nil
    
    // Last valid position
    private var lastLocation: CLLocation? = nil
    
    /// Starts measuring from current position
    func start() {
        
        // End old session first
        stop()
        lastLocation = nil
        
        // Must be created while app is in foreground
        backgroundSession = CLBackgroundActivitySession()
        
        updatesTask = Task { [weak self] in
            do {
                // New position about every second, tuned for workouts
                for try await update in CLLocationUpdate.liveUpdates(.fitness) {
                    if Task.isCancelled { break }
                    
                    if let location = update.location {
                        self?.handle(location)
                    }
                }
            } catch {
                // Updates ended
            }
        }
    }
    
    /// Stops measuring
    func stop() {
        updatesTask?.cancel()
        updatesTask = nil
        
        backgroundSession?.invalidate()
        backgroundSession = nil
    }
    
    /// Checks new position and passes on distance since last good one
    private func handle(_ location: CLLocation) {
        // Negative accuracy means invalid
        guard location.horizontalAccuracy >= 0, location.horizontalAccuracy <= Configuration.gpsMaxAccuracy
                else { return }
        
        // First good position
        guard let lastLocation else {
            self.lastLocation = location
            return
        }
        
        let meters: Double = location.distance(from: lastLocation)
        let seconds: Double = location.timestamp.timeIntervalSince(lastLocation.timestamp)
        
        // Ignore noise while standing still
        guard meters >= Configuration.gpsMinStep, seconds > 0 else { return }
        
        // Ignore jumps
        guard meters / seconds <= Configuration.maxRunningSpeed else { return }
        
        self.lastLocation = location
        onDistanceChange?(meters)
    }
}
