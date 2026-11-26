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
    
    // Current pace updates
    static let paceWindow: TimeInterval = 30
    
    // Min pace distance for updates
    static let minimumPaceDistance: Double = 20
    
    // No feedback at start of run - 2 minutes to warm up
    static let feedbackWarmup: TimeInterval = 120
    
    // No feedback right after resume - 30 seconds
    static let feedbackResume: TimeInterval = 30
    
    // Toggle audio feedback - name under which setting is stored
    static let audioFeedbackKey: String = "audioFeedbackEnabled"
    
    // Allowed values for own max heart rate (bpm)
    static let customMaxHeartRateRange: ClosedRange<Int> = 120...230
}
