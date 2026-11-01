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
    var username: String
    var birthDate: Date
    var createdAt: Date
    
    /*
     var age: Int {
         Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
     }
     
     var maxHeartRate: Int {
         Int((208 - 0.7 * Double(age)).rounded())
     }
     */
    
    init(username: String, birthDate: Date, createdAt: Date) {
        self.username = username
        self.birthDate = birthDate
        self.createdAt = createdAt
    }
}
