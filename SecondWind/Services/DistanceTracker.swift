//
//  DistanceTracker.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import Foundation

/// Shared interface for GPS and pedometer
protocol DistanceTracker: AnyObject {
    
    // Called with meters moved since last call
    var onDistanceChange: ((Double) -> Void)? { get set }
    
    /// Starts measuring from current position and time
    func start()
    
    /// Stops measuring, e.g. on pause or end of run
    func stop()
}
