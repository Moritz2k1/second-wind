//
//  AppLog.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 27.11.26.
//

import Foundation
import Observation
import OSLog
import UIKit

/// Area of the app a log entry comes from
enum LogCategory: String, Codable {
    case run = "Run"
    case audio = "Audio"
    case bluetooth = "Bluetooth"
}

/// One line in the in-app log
struct LogEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let category: LogCategory
    let message: String
    
    init(category: LogCategory, message: String) {
        id = UUID()
        date = .now
        self.category = category
        self.message = message
    }
}

/// Collects events of runs, shown in Profile so problems can be checked afterwards
@Observable
final class AppLog {
    
    // One log for the whole app
    static let shared: AppLog = AppLog()
    
    // Oldest first
    private(set) var entries: [LogEntry] = []
    
    // Also visible in Console.app on Mac
    private let logger: Logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "SecondWind", category: "App")
    
    // Kept on device, so entries survive app restarts
    private let fileURL: URL = URL.documentsDirectory.appending(path: "log.json")
    
    private init() {
        load()
    }
    
    /// Adds entry, removes oldest ones above limit
    func add(_ message: String, category: LogCategory) {
        entries.append(LogEntry(category: category, message: message))
        
        if entries.count > Configuration.maxLogEntries {
            entries.removeFirst(entries.count - Configuration.maxLogEntries)
        }
        
        logger.info("[\(category.rawValue)] \(message)")
        save()
    }
    
    /// Removes all entries
    func clear() {
        entries = []
        save()
    }
    
    /// All entries as plain text, e.g. for sharing
    var text: String {
        var lines: [String] = []
        
        for entry in entries {
            let time: String = entry.date.formatted(date: .numeric, time: .standard)
            lines.append("\(time) [\(entry.category.rawValue)] \(entry.message)")
        }
        
        return lines.joined(separator: "\n")
    }
    
    /// e.g. "background" - shows if screen was locked when something happened
    static var appState: String {
        switch UIApplication.shared.applicationState {
        case .active: return "foreground"
        case .inactive: return "inactive"
        case .background: return "background"
        @unknown default: return "unknown"
        }
    }
    
    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
    
    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let saved = try? JSONDecoder().decode([LogEntry].self, from: data)
        else { return }
        
        entries = saved
    }
}
