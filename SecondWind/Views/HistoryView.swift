//
//  HistoryView.swift
//  SecondWind
//
//  Created by Moritz Gutschi on 25.11.26.
//

import SwiftUI
import SwiftData
import Charts

/// Statistics and list of past runs
struct HistoryView: View {
    
    // All saved runs - newest first
    @Query(sort: \Run.startDate, order: .reverse) private var runs: [Run]
    
    // Filter and calculations
    @State private var viewModel: HistoryViewModel = HistoryViewModel()
    
    var body: some View {
        Group {
            if runs.isEmpty {
                emptyState
            } else {
                content
            }
        }
        .screenBackground()
    }
    
    private var content: some View {
        
        // Filtered once, used by all sections
        let filteredRuns: [Run] = viewModel.filteredRuns(runs)
        
        return ScrollView {
            VStack(spacing: Spacing.large) {
                ScreenHeader(title: "History")
                filterPicker
                statisticsGrid(viewModel.statistics(for: filteredRuns))
                weeklyChart(viewModel.weeklyDistance(for: filteredRuns))
                runList(filteredRuns)
            }
            .padding(.horizontal, Spacing.large)
            .padding(.vertical, Spacing.large)
        }
        .scrollBounceBehavior(.basedOnSize)
    }
    
    private var emptyState: some View {
        ContentUnavailableView(
            "No runs yet",
            systemImage: "figure.run"
        )
    }
    
    private var filterPicker: some View {
        Picker("Run type", selection: $viewModel.filter) {
            ForEach(RunFilter.allCases, id: \.self) { filter in
                Text(filter.title)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private func statisticsGrid(_ statistics: RunStatistics) -> some View {
        Grid(horizontalSpacing: Spacing.medium, verticalSpacing: Spacing.medium) {
            GridRow {
                StatTile(
                    title: "Runs",
                    value: "\(statistics.runCount)",
                    systemImage: "figure.run"
                )
                
                StatTile(
                    title: "Distance",
                    value: "≈ \(RunFormat.distance(statistics.totalDistanceKm))",
                    unit: "km",
                    systemImage: "map"
                )
            }
            
            GridRow {
                StatTile(
                    title: "Time",
                    value: RunFormat.duration(statistics.totalDuration),
                    systemImage: "clock"
                )
                
                StatTile(
                    title: "In target zone",
                    value: RunFormat.percent(statistics.timeInZoneRatio),
                    systemImage: "target"
                )
            }
            
            GridRow {
                StatTile(
                    title: "Average pace",
                    value: RunFormat.pace(statistics.averagePaceSecondsPerKm),
                    unit: "/km",
                    systemImage: "speedometer"
                )
                // Spans both columns
                .gridCellColumns(2)
            }
        }
    }
    
    private func weeklyChart(_ weeks: [WeeklyDistance]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text("Distance per week")
                .font(.headline)
                .foregroundStyle(ColorToken.primaryText)
            
            Chart(weeks) { week in
                BarMark(
                    x: .value("Week", week.weekStart, unit: .weekOfYear),
                    y: .value("Distance", week.distanceKm)
                )
                .foregroundStyle(ColorToken.chartBar)
                .cornerRadius(Radius.chartBar)
            }
            
            // Date below each bar
            .chartXAxis {
                AxisMarks(values: .stride(by: .weekOfYear)) {
                    AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                        .foregroundStyle(ColorToken.chartAxis)
                }
            }
            
            // Faint lines with km values on the right
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(ColorToken.chartGrid)
                    
                    AxisValueLabel {
                        if let km = value.as(Double.self) {
                            Text("\(Int(km)) km")
                        }
                    }
                    .foregroundStyle(ColorToken.chartAxis)
                }
            }
            .frame(height: 160)
        }
        .cardStyle()
    }
    
    private func runList(_ runs: [Run]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text("Runs")
                .font(.headline)
                .foregroundStyle(ColorToken.primaryText)
            
            if runs.isEmpty {
                Text(viewModel.emptyFilterText)
                    .font(.subheadline)
                    .foregroundStyle(ColorToken.secondaryText)
            } else {
                LazyVStack(spacing: Spacing.medium) {
                    ForEach(runs) { run in
                        RunRow(run: run)
                    }
                }
            }
        }
    }
}

#Preview("With runs") {
    HistoryView()
        .modelContainer(.preview)
}

#Preview("Empty") {
    HistoryView()
        .modelContainer(for: Run.self, inMemory: true)
}
