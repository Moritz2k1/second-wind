//
//  ProfileStore.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import Foundation
import Observation

/// Single source of truth for user profile
@Observable
class ProfileStore {
    
    // nil until profile setup is finished
    private(set) var profile: UserProfile?
    
    // Loads saved profile, previews can pass a sample instead
    init(profile: UserProfile? = UserProfile.loadProfile()) {
        self.profile = profile
    }
    
    /// Needed for zone boundaries
    var maxHeartRate: Int {
        profile?.maxHeartRate ?? 0
    }
    
    /// Saves profile on device and updates all screens
    func save(_ profile: UserProfile) {
        profile.saveProfile()
        self.profile = profile
    }
}
