//
//  ComingSoonView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 24.11.26.
//

import SwiftUI

/// Temporary screen
 struct ComingSoonView: View {
    let title: String
    let systemImage: String
    
    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: systemImage,
            description: Text("Coming soon")
        )
        .screenBackground()
    }
}
