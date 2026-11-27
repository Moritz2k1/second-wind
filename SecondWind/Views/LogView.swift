//
//  LogView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 27.11.26.
//

import SwiftUI

/// Sheet with app log, newest entries first
struct LogView: View {
    
    // Shared log, updates while sheet is open
    private let log: AppLog = AppLog.shared
    
    // Closes sheet
    @Environment(\.dismiss) private var dismiss
    
    // Asks before clearing
    @State private var showsClearConfirmation: Bool = false
    
    var body: some View {
        NavigationStack {
            content
                .screenBackground()
                .navigationTitle("Logs")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") { dismiss() }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        ShareLink(item: log.text)
                            .disabled(log.entries.isEmpty)
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        Button("Clear", systemImage: "trash") { showsClearConfirmation = true }
                            .disabled(log.entries.isEmpty)
                    }
                }
                .confirmationDialog("Clear all logs?", isPresented: $showsClearConfirmation, titleVisibility: .visible) {
                    Button("Clear logs", role: .destructive) { log.clear() }
                    Button("Cancel", role: .cancel) { }
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if log.entries.isEmpty {
            ContentUnavailableView(
                "No logs yet",
                systemImage: "doc.text",
                description: Text("Events from your runs show up here")
            )
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: Spacing.small) {
                    // Newest first
                    ForEach(log.entries.reversed()) { entry in
                        LogRow(entry: entry)
                    }
                }
                .padding(.horizontal, Spacing.large)
                .padding(.vertical, Spacing.medium)
            }
        }
    }
}

/// Time, category and message of one entry
private struct LogRow: View {
    
    let entry: LogEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small / 2) {
            HStack {
                Text(entry.category.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(ColorToken.accent)
                
                Spacer()
                
                Text(entry.date.formatted(date: .abbreviated, time: .standard))
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(ColorToken.secondaryText)
            }
            
            Text(entry.message)
                .font(.footnote.monospaced())
                .foregroundStyle(ColorToken.primaryText)
                .textSelection(.enabled)
        }
        .cardStyle()
    }
}

#Preview {
    LogView()
}
