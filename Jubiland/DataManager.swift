//
//  DataManager.swift
//  Jubiland
//
//  Created for Jubilant App
//

import Foundation
import SwiftUI
import Combine

class DataManager: ObservableObject {
    // Published properties for UI updates
    @Published var moodEntries: [MoodEntry] = []
    @Published var celebrations: [Celebration] = []
    
    // File URLs for data storage
    private let moodEntriesURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("moodEntries.json")
    private let celebrationsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("celebrations.json")
    
    init() {
        loadData()
    }
    
    // MARK: - Mood Entries Methods
    
    func addMoodEntry(_ entry: MoodEntry) {
        moodEntries.append(entry)
        saveMoodEntries()
    }
    
    func updateMoodEntry(_ entry: MoodEntry) {
        if let index = moodEntries.firstIndex(where: { $0.id == entry.id }) {
            moodEntries[index] = entry
            saveMoodEntries()
        }
    }
    
    func deleteMoodEntry(_ entry: MoodEntry) {
        moodEntries.removeAll { $0.id == entry.id }
        saveMoodEntries()
    }
    
    func getMoodEntries(for date: Date) -> [MoodEntry] {
        let calendar = Calendar.current
        return moodEntries.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    // MARK: - Celebrations Methods
    
    func addCelebration(_ celebration: Celebration) {
        celebrations.append(celebration)
        saveCelebrations()
    }
    
    func updateCelebration(_ celebration: Celebration) {
        if let index = celebrations.firstIndex(where: { $0.id == celebration.id }) {
            celebrations[index] = celebration
            saveCelebrations()
        }
    }
    
    func deleteCelebration(_ celebration: Celebration) {
        celebrations.removeAll { $0.id == celebration.id }
        saveCelebrations()
    }
    
    func getCelebrations(for date: Date) -> [Celebration] {
        let calendar = Calendar.current
        return celebrations.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    func toggleStarCelebration(_ celebration: Celebration) {
        if let index = celebrations.firstIndex(where: { $0.id == celebration.id }) {
            celebrations[index].isStarred.toggle()
            saveCelebrations()
        }
    }
    
    // MARK: - Data Persistence
    
    private func loadData() {
        loadMoodEntries()
        loadCelebrations()
    }
    
    private func saveMoodEntries() {
        do {
            let data = try JSONEncoder().encode(moodEntries)
            try data.write(to: moodEntriesURL)
        } catch {
            print("Error saving mood entries: \(error)")
        }
    }
    
    private func loadMoodEntries() {
        do {
            if let data = try? Data(contentsOf: moodEntriesURL) {
                moodEntries = try JSONDecoder().decode([MoodEntry].self, from: data)
            }
        } catch {
            print("Error loading mood entries: \(error)")
            moodEntries = []
        }
    }
    
    private func saveCelebrations() {
        do {
            let data = try JSONEncoder().encode(celebrations)
            try data.write(to: celebrationsURL)
        } catch {
            print("Error saving celebrations: \(error)")
        }
    }
    
    private func loadCelebrations() {
        do {
            if let data = try? Data(contentsOf: celebrationsURL) {
                celebrations = try JSONDecoder().decode([Celebration].self, from: data)
            }
        } catch {
            print("Error loading celebrations: \(error)")
            celebrations = []
        }
    }
    
    // MARK: - Analytics Methods
    
    func getAverageMood(for timeRange: TimeRange = .week) -> Double {
        let filteredEntries = filterMoodEntries(by: timeRange)
        guard !filteredEntries.isEmpty else { return 0 }
        
        let sum = filteredEntries.reduce(0) { $0 + $1.rating }
        return Double(sum) / Double(filteredEntries.count)
    }
    
    func getMoodDistribution(for timeRange: TimeRange = .month) -> [Int: Int] {
        let filteredEntries = filterMoodEntries(by: timeRange)
        var distribution: [Int: Int] = [1: 0, 2: 0, 3: 0, 4: 0, 5: 0]
        
        for entry in filteredEntries {
            distribution[entry.rating, default: 0] += 1
        }
        
        return distribution
    }
    
    func getCelebrationCount(for timeRange: TimeRange = .month) -> Int {
        filterCelebrations(by: timeRange).count
    }
    
    // Helper method to filter entries by time range
    private func filterMoodEntries(by timeRange: TimeRange) -> [MoodEntry] {
        let calendar = Calendar.current
        let now = Date()
        
        switch timeRange {
        case .day:
            return moodEntries.filter { calendar.isDateInToday($0.date) }
        case .week:
            guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now) else { return [] }
            return moodEntries.filter { $0.date >= oneWeekAgo && $0.date <= now }
        case .month:
            guard let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: now) else { return [] }
            return moodEntries.filter { $0.date >= oneMonthAgo && $0.date <= now }
        case .year:
            guard let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: now) else { return [] }
            return moodEntries.filter { $0.date >= oneYearAgo && $0.date <= now }
        case .all:
            return moodEntries
        }
    }
    
    private func filterCelebrations(by timeRange: TimeRange) -> [Celebration] {
        let calendar = Calendar.current
        let now = Date()
        
        switch timeRange {
        case .day:
            return celebrations.filter { calendar.isDateInToday($0.date) }
        case .week:
            guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now) else { return [] }
            return celebrations.filter { $0.date >= oneWeekAgo && $0.date <= now }
        case .month:
            guard let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: now) else { return [] }
            return celebrations.filter { $0.date >= oneMonthAgo && $0.date <= now }
        case .year:
            guard let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: now) else { return [] }
            return celebrations.filter { $0.date >= oneYearAgo && $0.date <= now }
        case .all:
            return celebrations
        }
    }
}

// Time range enum for analytics
enum TimeRange {
    case day, week, month, year, all
    
    var description: String {
        switch self {
        case .day: return "Today"
        case .week: return "This Week"
        case .month: return "This Month"
        case .year: return "This Year"
        case .all: return "All Time"
        }
    }
} 