//
//  HomeView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 05.11.26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Query private var profile: [UserProfile]
    
    var body: some View {
        if let profile: UserProfile = profile.first {
            Text("Welcome, \(profile.username)")
        }
    }
}
