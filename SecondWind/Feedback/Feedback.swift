//
//  Feedback.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 02.11.26.
//

import AVFoundation
import Combine

// Evaluates heart rate against target zone and delivers audio feedback
class Feedback: ObservableObject {
    
    // Properties
    // Converts text to speech
    private let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    // Tracks when last feedback was given
    private var lastFeedback: Date = .distantPast
    
}
