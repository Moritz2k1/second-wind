//
//  ProfileSetupViewModel.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 02.11.26.
//

import Foundation
import Observation

@Observable
class ProfileSetupViewModel {
    
    // Health Kit Service
    private let healthKitService: HealthKitService = HealthKitService()
    
    // Properties
    var username: String = ""
    
    // Defaults to 30 years of age
    var birthDate: Date = Calendar.current.date(
        byAdding: .year,
        value: -30,
        to: Date()
    ) ?? Date()
    
    var importedFromHealth: Bool = false
    
    // Own max heart rate instead of estimate
    var usesCustomMaxHeartRate: Bool = false
    var customMaxHeartRate: Int = 185
    
    // Empty form for first setup
    init() { }
    
    // Fills in existing values, used when editing
    init(profile: UserProfile) {
        username = profile.username
        birthDate = profile.birthDate
        usesCustomMaxHeartRate = profile.hasCustomMaxHeartRate
        
        // Starts at estimate -> switching on doesn't jump to random number
        customMaxHeartRate = profile.customMaxHeartRate ?? profile.estimatedMaxHeartRate
    }
    
    // Check if username is valid (should not contain whitespaces)
    var isValid: Bool {
        !trimName(username).isEmpty
    }
    
    var birthDateInfo: String {
        if importedFromHealth {
            return "Imported from Apple Health. You may change it if it's incorrect."
        } else {
            return "Used to estimate your maximum heart rate."
        }
    }
    
    // Hint below max heart rate setting
    var customMaxHeartRateInfo: String {
        if usesCustomMaxHeartRate {
            return "Estimate for your age would be \(estimatedMaxHeartRate) bpm."
        } else {
            return "Only switch on if you measured it, e.g. in a lab test or an all-out run."
        }
    }
    
    // Calculated from birthday
    var estimatedMaxHeartRate: Int {
        createProfile().estimatedMaxHeartRate
    }
    
    // Value zones will use after saving
    var maxHeartRate: Int {
        createProfile().maxHeartRate
    }
    
    /// Fetch birth date from health app
    func loadDateOfBirthFromHealth() async {
        guard let date = await healthKitService.fetchDateOfBirth() else { return }
        
        birthDate = date
        importedFromHealth = true
    }
    
    /// Function for creating a profile
    func createProfile() -> UserProfile {
        return UserProfile(
            username: trimName(username),
            birthDate: birthDate,
            customMaxHeartRate: usesCustomMaxHeartRate ? customMaxHeartRate : nil
        )
    }
    
    /// Helper for trimming username
    private func trimName(_ name: String) -> String {
        name.trimmingCharacters(in: .whitespaces)
    }
}
