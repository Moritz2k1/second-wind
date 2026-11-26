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
    
}
