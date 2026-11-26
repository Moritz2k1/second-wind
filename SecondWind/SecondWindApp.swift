//
//  SecondWindApp.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 31.10.26.
//

import SwiftUI
import SwiftData

@main
struct SecondWindApp: App {
    
    // Shared profile - passed to all screens
    @State private var profileStore: ProfileStore = ProfileStore()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .tint(Color.accent)
                .environment(profileStore)
        }
        
        // Stores run on device
        .modelContainer(for: Run.self)
    }
}
