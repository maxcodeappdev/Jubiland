//
//  DailyMoodView.swift
//  Jubiland
//
//  Created by Max Contreras on 2/25/25.
//

import SwiftUI



struct DailyMoodView: View {
    @EnvironmentObject private var dataManager: DataManager
    @State private var currentMood: Double = 3
    @State private var moodNote: String = ""
    @State private var showingConfirmation = false
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Date selector
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding(.horizontal)
                    .onChange(of: selectedDate) { _ in
                        loadMoodForSelectedDate()
                    }
                    
                    // Mood section
                    VStack(spacing: 16) {
                        Text("How are you feeling?")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        // Mood emoji display
                        Text(moodEmoji)
                            .font(.system(size: 80))
                            .padding()
                            .background(
                                Circle()
                                    .fill(moodColor.opacity(0.2))
                                    .frame(width: 150, height: 150)
                            )
                        
                        // Mood description
                        Text(moodDescription)
                            .font(.headline)
                            .foregroundColor(moodColor)
                        
                        // Mood slider
                        HStack {
                            Text("😔")
                            Slider(value: $currentMood, in: 1...5, step: 1)
                                .accentColor(moodColor)
                            Text("😊")
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    .padding(.horizontal)
                    
                    // Notes section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add a note")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        TextEditor(text: $moodNote)
                            .frame(minHeight: 100)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                    // Save button
                    Button(action: saveMood) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Mood")
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(14)
                        .shadow(color: Color.purple.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Affirmation card
                    if let affirmation = generateAffirmation() {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Today's Affirmation")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text(affirmation)
                                .font(.system(size: 18, weight: .medium, design: .serif))
                                .foregroundColor(.primary)
                                .italic()
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            HStack {
                                Spacer()
                                Image(systemName: "sparkles")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray6))
                        )
                        .padding(.horizontal)
                        .padding(.top, 16)
                    }
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Daily Mood")
            .onAppear {
                loadMoodForSelectedDate()
            }
            .alert(isPresented: $showingConfirmation) {
                Alert(
                    title: Text("Mood Saved"),
                    message: Text("Your mood has been recorded for \(formattedDate)."),
                    dismissButton: .default(Text("Great!"))
                )
            }
        }
    }
    
    // MARK: - Computed Properties
    
    var moodEmoji: String {
        switch Int(currentMood) {
        case 1: return "😔"
        case 2: return "😕"
        case 3: return "😐"
        case 4: return "🙂"
        case 5: return "😊"
        default: return "😐"
        }
    }
    
    var moodDescription: String {
        switch Int(currentMood) {
        case 1: return "Sad"
        case 2: return "Down"
        case 3: return "Neutral"
        case 4: return "Good"
        case 5: return "Great"
        default: return "Neutral"
        }
    }
    
    var moodColor: Color {
        switch Int(currentMood) {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .blue
        default: return .gray
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
    
    // MARK: - Methods
    
    func saveMood() {
        // Create a new mood entry
        let entry = MoodEntry(
            date: selectedDate,
            rating: Int(currentMood),
            note: moodNote
        )
        
        // Check if there's already an entry for this date
        let existingEntries = dataManager.getMoodEntries(for: selectedDate)
        
        if let existingEntry = existingEntries.first {
            // Update existing entry
            var updatedEntry = existingEntry
            updatedEntry.rating = Int(currentMood)
            updatedEntry.note = moodNote
            dataManager.updateMoodEntry(updatedEntry)
        } else {
            // Add new entry
            dataManager.addMoodEntry(entry)
        }
        
        // Show confirmation
        showingConfirmation = true
    }
    
    func loadMoodForSelectedDate() {
        let entries = dataManager.getMoodEntries(for: selectedDate)
        
        if let todayEntry = entries.first {
            currentMood = Double(todayEntry.rating)
            moodNote = todayEntry.note
        } else {
            // Reset to default values if no entry exists
            currentMood = 3
            moodNote = ""
        }
    }
    
    func generateAffirmation() -> String? {
        // Only show affirmations for today
        guard Calendar.current.isDateInToday(selectedDate) else {
            return nil
        }
        
        let affirmations = [
            "You're doing amazing! Keep celebrating the small wins.",
            "Every step forward is progress, no matter how small.",
            "Your feelings are valid, and you're handling them well.",
            "Today is a new opportunity to be kind to yourself.",
            "Remember to celebrate your strengths and achievements.",
            "You have the power to make today a good day.",
            "Small moments of joy add up to a happy life.",
            "You're stronger than you think and braver than you believe.",
            "Take a moment to appreciate how far you've come.",
            "Your best is enough, and you're doing great."
        ]
        
        // Use the current mood to select an appropriate affirmation
        let moodIndex = Int(currentMood)
        let affirmationIndex = (moodIndex * 2) % affirmations.count
        
        return affirmations[affirmationIndex]
    }
}

#Preview {
    DailyMoodView()
}
