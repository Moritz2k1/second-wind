//
//  RootView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 05.11.26.
//

import SwiftData
import SwiftUI

struct RootView: View {
    
    // Remembered on the device
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @AppStorage("hasCompletedProfile") private var hasCompletedProfile: Bool = false
    
    var body: some View {
        if !hasSeenOnboarding {
            //
        } else if !hasCompletedProfile {
            ProfileSetupView()
        } else {
            HomeView()
        }
    }
    
#Preview {
    RootView()
}
