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
    @AppStorage("seenOnboarding") private var seenOnboarding: Bool = false
    
    var body: some View {}
}
