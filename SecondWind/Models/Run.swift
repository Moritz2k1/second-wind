//
//  Run.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 24.11.26.
//

import Foundation
import SwiftData

// Where run took place
enum RunType: String, Codable, CaseIterable {
    case outdoor
    case indoor
    
    var title: String {
        switch self {
        case .outdoor: return "Outdoor run"
        case .indoor: return "Indoor run"
        }
    }
    
    var systemImage: String {
        switch self {
        case .outdoor: return "figure.run"
        case .indoor: return "figure.run.treadmill"
        }
    }
}
