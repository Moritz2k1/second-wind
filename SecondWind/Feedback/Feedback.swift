//
//  Feedback.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 02.11.26.
//

import AVFoundation

// Evaluates heart rate against target zone and delivers audio feedback
class Feedback: NSObject {
    
    // Properties
    // Converts text to speech
    private let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    // Tracks when last feedback was given
    private var lastFeedback: Date = .distantPast
    
    override init() {
        super.init()
        
        // When speaking is finished
        synthesizer.delegate = self
        
        // Speak over music - music gets quieter meanwhile
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        try? session.setCategory(
            .playback,
            mode: .voicePrompt,
            options: [.duckOthers, .interruptSpokenAudioAndMixWithOthers]
        )
    }
    
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
    
    /// Stops current message
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    /// Speaks given message and updates cooldown timer
    private func speak(message: String) -> Void {
        
        // Music gets quieter
        try? AVAudioSession.sharedInstance().setActive(true)
        
        let speech = AVSpeechUtterance(string: message)
        speech.voice = AVSpeechSynthesisVoice(language: "en-US")
        speech.rate = 0.45
        speech.volume = 1.0
        synthesizer.speak(speech)
        lastFeedback = Date()
    }
}

extension Feedback: AVSpeechSynthesizerDelegate {
    
    /// Called when message has been spoken - music gets loud again
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}
