//
//  ContentView.swift
//  Jubiland
//
//  Created by Max Contreras on 2/25/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DailyMoodView()
                .tabItem {
                    Label("Mood", systemImage: "face.smiling")
                }
                .tag(0)
            
            CelebrationsView()
                .tabItem {
                    Label("Celebrations", systemImage: "party.popper")
                }
                .tag(1)
            
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
        .accentColor(.purple) // Theme color for the app
    }
}

struct DailyMoodView: View {
    @State private var currentMood: Double = 3
    @State private var moodNote: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("How are you feeling today?")
                    .font(.title2)
                    .padding(.top)
                
                // Mood emoji display
                Text(moodEmoji)
                    .font(.system(size: 80))
                    .padding()
                
                // Mood slider
                Slider(value: $currentMood, in: 1...5, step: 1)
                    .padding(.horizontal)
                    .accentColor(.purple)
                
                // Mood labels
                HStack {
                    Text("😔")
                    Spacer()
                    Text("😐")
                    Spacer()
                    Text("😊")
                }
                .padding(.horizontal, 40)
                
                // Notes field
                TextField("Add a note about your day...", text: $moodNote)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // Save button
                Button(action: saveMood) {
                    Text("Save Today's Mood")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Daily Mood")
            .padding(.bottom)
        }
    }
    
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
    
    func saveMood() {
        // Here you would save the mood data
        // For now, we'll just print it
        print("Mood saved: \(Int(currentMood)), Note: \(moodNote)")
    }
}

struct CelebrationsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Your celebrations will appear here")
                    .foregroundColor(.secondary)
                
                Button(action: {
                    // Action to add a new celebration
                }) {
                    Label("Add New Celebration", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Celebrations")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct InsightsView: View {
    var body: some View {
        NavigationView {
            Text("Your mood and celebration insights will appear here")
                .navigationTitle("Insights")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Text("Settings options will appear here")
                .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
}
