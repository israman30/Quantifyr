//
//  HomeView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    FeatureCard(
                        title: "Unit Converter",
                        icon: "scalemass"
                    )
                    FeatureCard(
                        title: "Electrical",
                        icon: "bolt.fill"
                    )
                    
                    FeatureCard(
                        title: "Physics",
                        icon: "atom"
                    )
                    
                    FeatureCard(
                        title: "Frequency",
                        icon: "waveform"
                    )
                }
                .padding()
            }
            .navigationTitle("Quantifyr")
        }
    }
}

#Preview {
    HomeView()
}

struct FeatureCard: View {
    let title: String
    let icon: String
    
    var body: some View {
        
        HStack {
            
            Image(systemName: icon)
                .font(.largeTitle)
            
            Text(title)
                .font(.headline)
            
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}
