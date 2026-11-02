//
//  User.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 31.10.26.
//

import SwiftData
import Foundation

// SwiftData model -> stored locally in app's db
@Model
class UserProfile {
    
    // Attributes (var = mutable)
    var username: String
    var birthDate: Date
    var createdAt: Date
    
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
    
    // Used for getting max heart rate of user
     var maxHeartRate: Int {
         
         /*
          Formula from Tanaka, Monahan and Seals (2001),
          "Age-predicted maximal heart rate revisited"
          */
         Int((208 - 0.7 * Double(age)).rounded())
     }
    
    init(username: String, birthDate: Date, createdAt: Date) {
        self.username = username
        self.birthDate = birthDate
        self.createdAt = createdAt
    }
}
