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
    // Converts text to speech, replaced if it gets stuck
    private var synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    // Tracks when last feedback was given
    private var lastFeedback: Date = .distantPast
    
    // Minimum time between two messages, set by run from user setting
    var interval: TimeInterval = Configuration.feedbackInterval
    
    // Message currently spoken, old messages reporting back are ignored
    private var currentUtterance: AVSpeechUtterance? = nil
    
    // Releases audio session if speech never reports back
    private var releaseTask: Task<Void, Never>? = nil
    
    override init() {
        super.init()
        
        // When speaking is finished
        synthesizer.delegate = self
        configureSession()
        observeAudioSession()
    }
    
    /// Compares current heart rate against zone boundaries and triggers audio feedback
    func evaluate(currentHR: Int, zone: TrainingZone, userMaxHR: Int) -> Void {
        
        // Compute absolute BPM boundaries for selected zone
        let zoneMin = zone.calcMinHR(userMaxHR: userMaxHR)
        let zoneMax = zone.calcMaxHR(userMaxHR: userMaxHR)
        
        // Skip if no HR signal received
        guard currentHR > 0 else { return }
        
        // Enforce cooldown to avoid repeated feedback
        guard Date().timeIntervalSince(lastFeedback) >= interval else { return }
        
        // Trigger audio feedback if not in selected zone
        if currentHR < zoneMin {
            speak(message: "Faster", heartRate: currentHR)
        }
        else if currentHR > zoneMax {
            speak(message: "Slower", heartRate: currentHR)
        }
    }
    
    /// Stops current message and gives audio back to other apps
    func stop() {
        if synthesizer.isSpeaking {
            resetSynthesizer()
        }
        
        deactivateSession()
    }
    
    /// Speaks given message and updates cooldown timer
    private func speak(message: String, heartRate: Int) -> Void {
        
        // Old message still waiting would block this one
        if synthesizer.isSpeaking {
            AppLog.shared.add("Old message still pending, synthesizer reset", category: .audio)
            resetSynthesizer()
        }
        
        // System may have reset configuration in the meantime
        configureSession()
        
        // Music gets quieter - if this fails, speaking would get stuck
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            AppLog.shared.add("Audio could not start (\(AppLog.appState)): \(error.localizedDescription)", category: .audio)
            
            // Try again soon instead of after full interval
            lastFeedback = Date().addingTimeInterval(Configuration.feedbackRetryDelay - interval)
            return
        }
        
        let speech = AVSpeechUtterance(string: message)
        speech.voice = AVSpeechSynthesisVoice(language: "en-US")
        speech.rate = 0.45
        speech.volume = 1.0
        
        currentUtterance = speech
        synthesizer.speak(speech)
        lastFeedback = Date()
        
        AppLog.shared.add("Speaking \"\(message)\" at \(heartRate) bpm (\(AppLog.appState))", category: .audio)
        scheduleSafetyRelease()
    }
    
    /// Playback over music, works with locked screen
    private func configureSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .voicePrompt,
                options: [.duckOthers, .interruptSpokenAudioAndMixWithOthers]
            )
        } catch {
            AppLog.shared.add("Audio category could not be set: \(error.localizedDescription)", category: .audio)
        }
    }
    
    /// Music gets loud again, other apps may continue
    private func deactivateSession() {
        releaseTask?.cancel()
        releaseTask = nil
        currentUtterance = nil
        
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            AppLog.shared.add("Audio could not be released: \(error.localizedDescription)", category: .audio)
        }
    }
    
    /// Gives audio back after timeout, even if speech never finished
    private func scheduleSafetyRelease() {
        releaseTask?.cancel()
        
        releaseTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(Configuration.speechTimeout))
            
            guard !Task.isCancelled, let self else { return }
            
            if self.synthesizer.isSpeaking {
                AppLog.shared.add("Speech stuck, synthesizer reset", category: .audio)
                self.resetSynthesizer()
            }
            
            AppLog.shared.add("Safety release of audio", category: .audio)
            self.deactivateSession()
        }
    }
    
    /// New synthesizer, a stuck one may never recover
    private func resetSynthesizer() {
        synthesizer.delegate = nil
        synthesizer.stopSpeaking(at: .immediate)
        
        synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        currentUtterance = nil
    }
    
    /// Reacts when other apps, calls or lock screen take over audio
    private func observeAudioSession() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption(_:)),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMediaServicesReset(_:)),
            name: AVAudioSession.mediaServicesWereResetNotification,
            object: nil
        )
    }
    
    /// Message is cancelled cleanly when audio is interrupted
    @objc private func handleInterruption(_ notification: Notification) {
        guard let info = notification.userInfo,
              let rawType = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: rawType)
        else { return }
        
        // Reason as number, e.g. app backgrounded or other app took over
        let reason: UInt = info[AVAudioSessionInterruptionReasonKey] as? UInt ?? 0
        
        switch type {
        case .began:
            AppLog.shared.add("Audio interrupted, reason \(reason) (\(AppLog.appState))", category: .audio)
            
            if currentUtterance != nil {
                resetSynthesizer()
            }
            
            releaseTask?.cancel()
            releaseTask = nil
            
        case .ended:
            AppLog.shared.add("Audio interruption ended (\(AppLog.appState))", category: .audio)
            
        @unknown default:
            break
        }
    }
    
    /// Audio system restarted, old synthesizer and settings are invalid
    @objc private func handleMediaServicesReset(_ notification: Notification) {
        AppLog.shared.add("Audio system was reset", category: .audio)
        resetSynthesizer()
        configureSession()
    }
}

extension Feedback: AVSpeechSynthesizerDelegate {
    
    /// Called when message has been spoken - music gets loud again
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // Ignore old messages, would release audio of new one
        guard utterance === currentUtterance else { return }
        deactivateSession()
    }
    
    /// Called when message was cut off - music gets loud again
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        guard utterance === currentUtterance else { return }
        deactivateSession()
    }
}
