//
//  PedometerDistanceTracker.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import CoreMotion

/// Estimates treadmill distance from steps
final class PedometerDistanceTracker: DistanceTracker {
    
    var onDistanceChange: ((Double) -> Void)? = nil
    
    // Apple's step counter
    private let pedometer: CMPedometer = CMPedometer()
    
    // Total meters at last update
    private var lastTotal: Double = 0
    
    /// Starts counting from now
    func start() {
        // End old updates first
        stop()
        lastTotal = 0
        
        // Not every device can estimate distance
        guard CMPedometer.isDistanceAvailable() else { return }
        
        // Called again and again with total distance since start
        pedometer.startUpdates(from: .now) { @Sendable [weak self] data, error in
            
            // If something went wrong, skip
            if error != nil {
                return
            }
            
            // No data yet
            guard let data else {
                return
            }
            
            // Not every update contains distance
            guard let distance = data.distance else {
                return
            }
            
            let totalMeters: Double = distance.doubleValue
            
            // Handler runs on background thread, handle on main thread
            Task { @MainActor [weak self] in
                self?.handle(totalMeters: totalMeters)
            }
        }
    }
    
    /// Stops counting
    func stop() {
        pedometer.stopUpdates()
    }
    
    /// Pedometer reports total since start
    private func handle(totalMeters: Double) {
        let meters: Double = totalMeters - lastTotal
        guard meters > 0 else { return }
        
        lastTotal = totalMeters
        onDistanceChange?(meters)
    }
}
