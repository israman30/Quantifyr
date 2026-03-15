//
//  HomeView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var searchText = ""
    @State private var isSearchFocused = false
    
    private var searchResults: [FormulaEntry] {
        FormulaRegistry.search(searchText)
    }
    
    private var favoriteEntries: [FormulaEntry] {
        FormulaRegistry.favorites(favoritesManager.favoriteIds)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Search
                    searchSection
                    
                    // Recent calculations
                    if !historyManager.records.isEmpty {
                        recentCalculationsSection
                    }
                    
                    // Favorites
                    if !favoriteEntries.isEmpty {
                        favoritesSection
                    }
                    
                    // Category cards
                    categorySection
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Quantifyr")
            .searchable(text: $searchText, prompt: "Search formulas: voltage, force, frequency...")
            .navigationDestination(for: String.self) { formulaId in
                FormulaRegistry.destination(for: formulaId)
            }
        }
    }
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !searchText.isEmpty {
                Text("Search results")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                if searchResults.isEmpty {
                    Text("No formulas match \"\(searchText)\"")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                        .padding(.vertical, 12)
                } else {
                    ForEach(searchResults) { entry in
                        NavigationLink(value: entry.id) {
                            FormulaSearchRow(entry: entry)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private var recentCalculationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent calculations")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Clear") {
                    historyManager.clear()
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 0) {
                ForEach(historyManager.records.prefix(10)) { record in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(record.formulaName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(record.result)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Menu {
                            Button {
                                UIPasteboard.general.string = "\(record.formulaName): \(record.result)"
                            } label: {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                            ShareLink(item: "\(record.formulaName): \(record.result)", subject: Text("Calculation"), message: Text("\(record.formulaName): \(record.result)")) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    
                    if record.id != historyManager.records.prefix(10).last?.id {
                        Divider()
                            .padding(.leading, 12)
                    }
                }
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Favorites")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(favoriteEntries) { entry in
                        NavigationLink(value: entry.id) {
                            FavoriteChip(entry: entry)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
            .frame(height: 48)
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Scientific Toolkit")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text("Enter known values → get results instantly")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .padding(.bottom, 4)
            
            VStack(spacing: 12) {
                CategoryCardLink(
                    title: "Unit Converter",
                    subtitle: "Length, weight, temperature, speed, energy",
                    icon: "arrow.left.arrow.right",
                    destination: { UnitConverterView() }
                )
                
                CategoryCardLink(
                    title: "Electrical",
                    subtitle: "Ohm's Law, Power, Resistors, Capacitance",
                    icon: "bolt.fill",
                    destination: { ElectricalView() }
                )
                
                CategoryCardLink(
                    title: "Physics",
                    subtitle: "Force, Kinetic Energy, Momentum",
                    icon: "atom",
                    destination: { PhysicsView() }
                )
                
                CategoryCardLink(
                    title: "Frequency",
                    subtitle: "Wavelength, RC filter",
                    icon: "waveform",
                    destination: { FrequencyView() }
                )
                
                CategoryCardLink(
                    title: "Math",
                    subtitle: "Metric prefixes: kilo, mega, giga, milli, micro, nano",
                    icon: "number",
                    destination: { MetricPrefixView() }
                )
            }
            
            // Advanced Features (Future Versions)
            advancedFeaturesSection
        }
    }
    
    private var advancedFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Advanced Features")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text("Professional tools for students")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .padding(.bottom, 4)
            
            VStack(spacing: 12) {
                FeatureBadge(
                    title: "Interactive Formulas",
                    subtitle: "Visual display: V = I × R",
                    icon: "function"
                )
                
                FeatureBadge(
                    title: "Calculation Steps",
                    subtitle: "Step-by-step solutions",
                    icon: "list.number"
                )
                
                FeatureBadge(
                    title: "Smart Keyboard",
                    subtitle: "Numeric pad + Done button",
                    icon: "keyboard"
                )
                
                FeatureBadge(
                    title: "Tap to Copy",
                    subtitle: "Tap result → copy to clipboard",
                    icon: "doc.on.doc"
                )
                
                FeatureBadge(
                    title: "Calculation History",
                    subtitle: "Recent calculations above",
                    icon: "clock.arrow.circlepath"
                )
                
                FutureFeatureCard(
                    title: "Graph Calculator",
                    subtitle: "Plot equations (coming soon)",
                    icon: "chart.line.uptrend.xyaxis"
                )
            }
        }
    }
}

// MARK: - Category Card Link
struct CategoryCardLink<Destination: View>: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    @ViewBuilder let destination: () -> Destination
    
    var body: some View {
        NavigationLink {
            destination()
        } label: {
            FeatureCard(title: title, subtitle: subtitle, icon: icon)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Formula Search Row
struct FormulaSearchRow: View {
    let entry: FormulaEntry
    @Environment(FavoritesManager.self) private var favoritesManager
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(entry.formula)
                    .font(.caption)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                favoritesManager.toggle(entry.id)
            } label: {
                Image(systemName: favoritesManager.isFavorite(entry.id) ? "star.fill" : "star")
                    .foregroundStyle(favoritesManager.isFavorite(entry.id) ? .yellow : .secondary)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Favorite Chip
struct FavoriteChip: View {
    let entry: FormulaEntry
    
    var body: some View {
        HStack(spacing: 6) {
            Text(entry.name)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.background)
        .clipShape(Capsule())
    }
}

// MARK: - Feature Badge (implemented)
struct FeatureBadge: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.green)
                .frame(width: 44, height: 44)
                .background(.green.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Future Feature Card
struct FutureFeatureCard: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.tertiary)
                .frame(width: 44, height: 44)
                .background(.primary.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
        }
        .padding()
        .background(.background.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Feature Card
struct FeatureCard: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.primary)
                .frame(width: 44, height: 44)
                .background(.primary.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HomeView()
        .environment(HistoryManager.shared)
        .environment(FavoritesManager.shared)
}
