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
    
    /// Compares current heart rate against zone boundaries and triggers audio feedback
    func evaluate(currentHR: Int, zone: TrainingZone, userMaxHR: Int) -> Void {
        
        // Compute absolute BPM boundaries for selected zone
        let zoneMin = zone.calcMinHR(userMaxHR: userMaxHR)
        let zoneMax = zone.calcMaxHR(userMaxHR: userMaxHR)
        
        // Skip if no HR signal received
        guard currentHR > 0 else { return }
        
        // Enforce cooldown to avoid repeated feedback
        guard Date().timeIntervalSince(lastFeedback) >= Configuration.feedbackInterval else { return }
        
        // Trigger audio feedback if not in selected zone
        if currentHR < zoneMin {
            speak(message: "Faster")
        }
        else if currentHR > zoneMax {
            speak(message: "Slower")
        }
    }
    
    // Speaks given message and updates cooldown timer
    private func speak(message: String) -> Void {
        let speech = AVSpeechUtterance(string: message)
        speech.voice = AVSpeechSynthesisVoice(language: "en-US")
        speech.rate = 0.45
        speech.volume = 1.0
        synthesizer.speak(speech)
        lastFeedback = Date()
    }
}
