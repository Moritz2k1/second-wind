//
//  HistoryViewModel.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 25.11.26.
//

import Foundation
import Observation

/// Filter for history
enum RunFilter: CaseIterable {
    case all
    case outdoor
    case indoor
    
    var title: String {
        switch self {
        case .all: return "All"
        case .outdoor: return "Outdoor"
        case .indoor: return "Indoor"
        }
    }
}

@Observable
class HistoryViewModel {
    
    // Selected segment in picker
    var filter: RunFilter = .all
    
    /// Runs matching selected filter
    func filteredRuns(_ runs: [Run]) -> [Run] {
        var result: [Run] = []
        
        for run in runs {
            if matches(run) {
                result.append(run)
            }
        }
        
        return result
    }
    
    /// Checks if run belongs to selected filter
    private func matches(_ run: Run) -> Bool {
        switch filter {
        case .all:
            return true
        case .outdoor:
            return run.type == .outdoor
        case .indoor:
            return run.type == .indoor
        }
    }
    
    /// Totals for stat tiles
    func statistics(for runs: [Run]) -> RunStatistics {
        RunStatistics(runs: runs)
    }
    
    /// Bars for weekly chart
    func weeklyDistance(for runs: [Run]) -> [WeeklyDistance] {
        RunStatistics.weeklyDistance(of: runs)
    }
    
    /// Shown when filter has no runs
    var emptyFilterText: String {
        "No \(filter.title.lowercased()) runs yet"
    }
    
}
