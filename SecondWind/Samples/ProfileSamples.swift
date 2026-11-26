//
//  ProfileSamples.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

#if DEBUG
import Foundation

extension UserProfile {
    
    /// Example profile for previews, 30 years old
    static var sample: UserProfile {
        let birthDate: Date = Calendar.current.date(byAdding: .year, value: -30, to: .now) ?? .now
        return UserProfile(username: "Moritz Gutschi", birthDate: birthDate)
    }
}
#endif
