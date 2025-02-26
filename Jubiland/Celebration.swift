//
//  Celebration.swift
//  Jubiland
//
//  Created for Jubilant App
//

import Foundation
import SwiftUI

struct Celebration: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var date: Date
    var category: Category
    var mediaURLs: [URL] = []
    var isStarred: Bool = false
    
    enum Category: String, Codable, CaseIterable {
        case personal = "Personal"
        case work = "Work"
        case health = "Health"
        case relationship = "Relationship"
        case learning = "Learning"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .personal: return "person.fill"
            case .work: return "briefcase.fill"
            case .health: return "heart.fill"
            case .relationship: return "person.2.fill"
            case .learning: return "book.fill"
            case .other: return "star.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .personal: return .blue
            case .work: return .purple
            case .health: return .green
            case .relationship: return .pink
            case .learning: return .orange
            case .other: return .gray
            }
        }
    }
    
    // Default initializer
    init(title: String = "", description: String = "", date: Date = Date(), category: Category = .personal, mediaURLs: [URL] = [], isStarred: Bool = false) {
        self.title = title
        self.description = description
        self.date = date
        self.category = category
        self.mediaURLs = mediaURLs
        self.isStarred = isStarred
    }
} 