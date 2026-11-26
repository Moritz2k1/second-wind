//
//  FeedbackSettings.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import Foundation

/// User choices for audio feedback
struct FeedbackSettings {
    
    // Feedback on or off
    var isEnabled: Bool
    
    // Minimum time between two messages
    var interval: TimeInterval
    
    // No messages at start of run
    var warmup: TimeInterval
    
    /// Reads saved choices, uses defaults from Configuration if never changed
    static func load() -> FeedbackSettings {
        let defaults: UserDefaults = UserDefaults.standard
        
        return FeedbackSettings(
            isEnabled: defaults.object(forKey: Configuration.audioFeedbackKey) as? Bool ?? true,
            interval: defaults.object(forKey: Configuration.feedbackIntervalKey) as? Double ?? Configuration.feedbackInterval,
            warmup: defaults.object(forKey: Configuration.feedbackWarmupKey) as? Double ?? Configuration.feedbackWarmup
        )
    }
}
