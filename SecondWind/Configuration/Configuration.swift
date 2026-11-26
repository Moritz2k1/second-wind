//
//  Configuration.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 31.10.26.
//

import Foundation

struct Configuration {
    
    // BLE Supported Devices
    static let supportedDevices: [String] = ["Polar"]
    
    // Define Feedback Interval in Seconds
    static let feedbackInterval: TimeInterval = 30
    
    // Shorter runs are not saved
    static let minimumRunDuration: TimeInterval = 60
    
    // No new heart rate for given duration
    static let heartRateTimeout: TimeInterval = 5
    
    // Ignored if less than
    static let gpsMaxAccuracy: Double = 20
    
    // Smaller steps = GPS noise
    static let gpsMinStep: Double = 3
    
    // Faster jumps = GPS errors
    static let maxRunningSpeed: Double = 10
}
