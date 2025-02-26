//
//  MoodEntry.swift
//  Jubiland
//
//  Created for Jubilant App
//

import Foundation
import SwiftUI

struct MoodEntry: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var rating: Int // 1-5 scale
    var note: String
    
    // Computed property to get emoji based on rating
    var emoji: String {
        switch rating {
        case 1: return "😔"
        case 2: return "😕"
        case 3: return "😐"
        case 4: return "🙂"
        case 5: return "😊"
        default: return "😐"
        }
    }
    
    // Computed property for mood description
    var moodDescription: String {
        switch rating {
        case 1: return "Sad"
        case 2: return "Down"
        case 3: return "Neutral"
        case 4: return "Good"
        case 5: return "Great"
        default: return "Neutral"
        }
    }
    
    // Default initializer
    init(date: Date = Date(), rating: Int = 3, note: String = "") {
        self.date = date
        self.rating = max(1, min(5, rating)) // Ensure rating is between 1-5
        self.note = note
    }
}

// Extension for color representation of mood
extension MoodEntry {
    var color: Color {
        switch rating {
        case 1: return .red.opacity(0.7)
        case 2: return .orange.opacity(0.7)
        case 3: return .yellow.opacity(0.7)
        case 4: return .green.opacity(0.7)
        case 5: return .blue.opacity(0.7)
        default: return .gray.opacity(0.7)
        }
    }
} 