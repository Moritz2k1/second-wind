//
//  ProfileSetupVM.swift
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
            createdAt: Date.now
        )
    }
    
    /// Helper for trimming username
    private func trimName(_ name: String) -> String {
        name.trimmingCharacters(in: .whitespaces)
    }
}
