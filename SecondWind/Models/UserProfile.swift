//
//  UserProfile.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 31.10.26.
//

import Foundation

struct UserProfile {
    
    // Attributes (var = mutable)
    var username: String
    var birthDate: Date
    
    // Own value from lab test or hard run, nil = use estimate
    var customMaxHeartRate: Int? = nil
    
    // Used for getting age of user
    var age: Int {
        
        // Current date and time
        let today: Date = Date()
        
        // Get how many full years lie between two dates
        let yearComponents: DateComponents =
        Calendar.current.dateComponents(
            [.year], from: birthDate, to: today
        )
        
        // Use year variable if there is one, otherwise 0
        let years: Int = yearComponents.year ?? 0
        
        return max(years, 0)
    }
    
    // Max heart rate calculated from age
    var estimatedMaxHeartRate: Int {
        
        /*
         Formula from Tanaka, Monahan and Seals (2001),
         "Age-predicted maximal heart rate revisited"
         */
        Int((208 - 0.7 * Double(age)).rounded())
    }
    
    // Used for all zones
    var maxHeartRate: Int {
        customMaxHeartRate ?? estimatedMaxHeartRate
    }
    
    // True if user entered own max heart rate
    var hasCustomMaxHeartRate: Bool {
        customMaxHeartRate != nil
    }
    
    /// First letters of first and last name
    var initials: String {
        let words = username.split(separator: " ")
        var result: String = ""
        
        for word in words.prefix(2) {
            if let first = word.first {
                result.append(first)
            }
        }
        
        return result.uppercased()
    }
    
    /// Writes profile to device
    func saveProfile() {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(username, forKey: "username")
        defaults.set(birthDate.timeIntervalSince1970, forKey: "birthDate")
        defaults.set(true, forKey: "hasCompletedProfile")
        
        // Remove old value when user switches back to estimate
        if let customMaxHeartRate {
            defaults.set(customMaxHeartRate, forKey: "customMaxHeartRate")
        } else {
            defaults.removeObject(forKey: "customMaxHeartRate")
        }
    }
    
    /// Reads profile from device, nil if none was saved yet
    static func loadProfile() -> UserProfile? {
        let defaults: UserDefaults = UserDefaults.standard
        
        guard let username: String = defaults.string(forKey: "username") else { return nil }
        
        let timestamp: Double = defaults.double(forKey: "birthDate")
        let birthDate: Date = Date(timeIntervalSince1970: timestamp)
        
        // nil if never set
        let customMaxHeartRate: Int? = defaults.object(forKey: "customMaxHeartRate") as? Int
        
        return UserProfile(
            username: username,
            birthDate: birthDate,
            customMaxHeartRate: customMaxHeartRate
        )
    }
}
