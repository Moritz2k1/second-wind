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
    
    // Set custom feedback and warmup interval
    static let feedbackIntervalKey: String = "feedbackInterval"
    static let feedbackWarmupKey: String = "feedbackWarmup"
    
    // Choices in Profile
    static let feedbackIntervalOptions: [TimeInterval] = [30, 60, 120]
    static let feedbackWarmupOptions: [TimeInterval] = [30, 60, 120]
    
    // If audio could not start, try again after this many seconds
    static let feedbackRetryDelay: TimeInterval = 5
    
    // Audio session is released at the latest after this, even if speech got stuck
    static let speechTimeout: TimeInterval = 5
    
    // How often heart rate is written to the log during a run
    static let heartRateLogInterval: TimeInterval = 30
    
    // Older log entries are removed
    static let maxLogEntries: Int = 500
    
    // Allowed values for own max heart rate (bpm)
    static let customMaxHeartRateRange: ClosedRange<Int> = 120...230
}
