//
//  HealthKitService.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 02.11.26.
//

import Foundation
import HealthKit

// Connect to Apple Health
class HealthKitService {
    
    private let healthStore: HKHealthStore = HKHealthStore()
    
    func fetchDateOfBirth() async -> Date? {
        
        // Check if Apple Health exists on device
        if !HKHealthStore.isHealthDataAvailable() { return nil }
        
        // Define which data to read
        guard let dateOfBirthType: HKCharacteristicType =
                HKObjectType.characteristicType(forIdentifier: .dateOfBirth)
                else { return nil }
        
        do {
            // Ask user for permission to read it
            try await healthStore.requestAuthorization(toShare: [], read: [dateOfBirthType])
            
            // Read date of birth
            let components: DateComponents = try healthStore.dateOfBirthComponents()
            
            // Turn components (year, month, day) into a date
            let dateOfBirth: Date? = Calendar.current.date(from: components)
            return dateOfBirth
        } catch {
            return nil
        }
        
    }
}
