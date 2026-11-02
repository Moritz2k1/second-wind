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
    
    // Properties
    var username: String = ""
    var birthDate: Date = Date()
    var importedFromHealth: Bool = false
    
    // Health Kit Service
    private let healthKitService: HealthKitService = HealthKitService()
    
    // Check if username is valid (should not contain whitespaces)
    var isValid: Bool {
        !trimName(username).isEmpty
    }
    
    /// Fetch birth date from health app
    func loadDateOfBirthFromHealth() async {
        guard let date = await healthKitService.fetchDateOfBirth() else { return }
        
        birthDate = date
        importedFromHealth = true
    }
    
    /// Function for creating a profile
    func makeProfile() -> UserProfile {
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
