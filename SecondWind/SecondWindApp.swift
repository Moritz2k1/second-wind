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
    
    // Constants for local database
    let container: ModelContainer
    
    init() {
        do {
            // Set up local database
            container = try ModelContainer()
        } catch {
            fatalError("Failed to create database: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
