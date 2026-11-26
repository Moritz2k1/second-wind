//
//  AppInfo.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 26.11.26.
//

import Foundation

/// Details about app, read from Info.plist
enum AppInfo {
    
    // Set in target under General - Version
    static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "–"
    }
    
    // Set in target under General - Build
    static var build: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "–"
    }
    
    static var fullVersion: String {
        "\(version) (\(build))"
    }
}
