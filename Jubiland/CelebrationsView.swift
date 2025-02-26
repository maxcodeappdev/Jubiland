//
//  CelebrationsView.swift
//  Jubiland
//
//  Created by Max Contreras on 2/25/25.
//

import SwiftUI

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

#Preview {
    CelebrationsView()
}
