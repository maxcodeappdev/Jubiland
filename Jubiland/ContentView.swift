//
//  ContentView.swift
//  Jubiland
//
//  Created by Max Contreras on 2/25/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
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
        .environmentObject(dataManager) // Pass the data manager to all views
    }
}








#Preview {
    ContentView()
}
