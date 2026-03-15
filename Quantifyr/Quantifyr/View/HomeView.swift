//
//  HomeView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

// MARK: - Home View
struct HomeView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @Environment(SpotlightRouter.self) private var spotlightRouter
    @State private var searchText = ""
    @State private var navigationPath = [String]()
    
    private var searchResults: [FormulaEntry] {
        FormulaRegistry.search(searchText)
    }
    
    private var favoriteEntries: [FormulaEntry] {
        FormulaRegistry.favorites(favoritesManager.favoriteIds)
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
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
            .background(
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(.systemGroupedBackground).opacity(0.95)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Quantifyr")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search formulas: voltage, force, frequency...")
            .navigationDestination(for: String.self) { formulaId in
                FormulaRegistry.destination(for: formulaId)
            }
            .onAppear {
                if let id = spotlightRouter.consumePendingNavigation() {
                    navigationPath.append(id)
                }
            }
            .onChange(of: spotlightRouter.formulaIdToOpen) { _, newId in
                if let id = spotlightRouter.consumePendingNavigation() {
                    navigationPath.append(id)
                }
            }
        }
    }
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !searchText.isEmpty {
                Text("Search results")
                    .font(AppTypography.sectionTitle)
                    .foregroundStyle(AppTheme.sectionTitle)
                
                if searchResults.isEmpty {
                    Text("No formulas match \"\(searchText)\"")
                        .font(AppTypography.subtitle)
                        .foregroundStyle(AppTheme.sectionSubtitle)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Recent calculations")
                    .font(AppTypography.sectionTitle)
                    .foregroundStyle(AppTheme.sectionTitle)
                Spacer()
                Button("Clear") {
                    historyManager.clear()
                }
                .font(AppTypography.caption2)
                .foregroundStyle(AppTheme.accent)
                .fontWeight(.medium)
            }
            
            VStack(spacing: 0) {
                ForEach(historyManager.records.prefix(10)) { record in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(record.formulaName)
                                .font(AppTypography.subtitle)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                            Text(record.result)
                                .font(AppTypography.caption)
                                .foregroundStyle(AppTheme.sectionSubtitle)
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
                                .font(.system(size: 18))
                                .foregroundStyle(AppTheme.sectionSubtitle)
                        }
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    
                    if record.id != historyManager.records.prefix(10).last?.id {
                        Divider()
                            .padding(.leading, 16)
                    }
                }
            }
            .cardStyle(cornerRadius: 14, hasShadow: true)
        }
    }
    
    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Favorites")
                .font(AppTypography.sectionTitle)
                .foregroundStyle(AppTheme.sectionTitle)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(favoriteEntries) { entry in
                        NavigationLink(value: entry.id) {
                            FavoriteChip(entry: entry)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 6)
            }
            .frame(height: 52)
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Scientific Toolkit")
                .font(AppTypography.sectionTitle)
                .foregroundStyle(AppTheme.sectionTitle)
            
            Text("Enter known values → get results instantly")
                .font(AppTypography.subtitle)
                .foregroundStyle(AppTheme.sectionSubtitle)
                .padding(.bottom, 6)
            
            VStack(spacing: 14) {
                CategoryCardLink(
                    title: "Unit Converter",
                    subtitle: "Length, weight, temperature, speed, energy",
                    icon: "arrow.left.arrow.right",
                    accent: AppTheme.Category.unitConverter,
                    destination: { UnitConverterView() }
                )
                
                CategoryCardLink(
                    title: "Electrical",
                    subtitle: "Ohm's Law, Power, Resistors, Capacitance",
                    icon: "bolt.fill",
                    accent: AppTheme.Category.electrical,
                    destination: { ElectricalView() }
                )
                
                CategoryCardLink(
                    title: "Physics",
                    subtitle: "Force, Kinetic Energy, Momentum",
                    icon: "atom",
                    accent: AppTheme.Category.physics,
                    destination: { PhysicsView() }
                )
                
                CategoryCardLink(
                    title: "Frequency",
                    subtitle: "Wavelength, RC filter",
                    icon: "waveform",
                    accent: AppTheme.Category.frequency,
                    destination: { FrequencyView() }
                )
                
                CategoryCardLink(
                    title: "Math",
                    subtitle: "Metric prefixes: kilo, mega, giga, milli, micro, nano",
                    icon: "number",
                    accent: AppTheme.Category.math,
                    destination: { MetricPrefixView() }
                )
                
                CategoryCardLink(
                    title: "Graph Equations",
                    subtitle: "Plot y = f(x): x², sin(x), 2x+1",
                    icon: "chart.line.uptrend.xyaxis",
                    accent: AppTheme.Category.math,
                    destination: { GraphView() }
                )
                
                CategoryCardLink(
                    title: "Constants",
                    subtitle: "π, c, G, h, ε₀, Avogadro, and more",
                    icon: "square.stack.3d.up",
                    accent: AppTheme.Category.physics,
                    destination: { ConstantsView() }
                )
            }
            
            // Advanced Features (Future Versions)
            advancedFeaturesSection
        }
    }
    
    private var advancedFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Advanced Features")
                .font(AppTypography.sectionTitle)
                .foregroundStyle(AppTheme.sectionTitle)
            
            Text("Professional tools for students")
                .font(AppTypography.subtitle)
                .foregroundStyle(AppTheme.sectionSubtitle)
                .padding(.bottom, 6)
            
            VStack(spacing: 12) {
                FeatureBadge(
                    title: "Formula Visualizer",
                    subtitle: "Color-coded variables, tap to learn",
                    icon: "function"
                )
                
                FeatureBadge(
                    title: "Unit Intelligence",
                    subtitle: "1000 m → suggests 1 km",
                    icon: "lightbulb.fill"
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
                
                FeatureBadge(
                    title: "Graph Equations",
                    subtitle: "Plot y = f(x) with Swift Charts",
                    icon: "chart.line.uptrend.xyaxis"
                )
                
                FeatureBadge(
                    title: "Spotlight Search",
                    subtitle: "Search formulas from Home screen",
                    icon: "magnifyingglass"
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
    var accent: Color = AppTheme.accent
    @ViewBuilder let destination: () -> Destination
    
    var body: some View {
        NavigationLink {
            destination()
        } label: {
            FeatureCard(title: title, subtitle: subtitle, icon: icon, accent: accent)
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
            VStack(alignment: .leading, spacing: 6) {
                Text(entry.name)
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(.primary)
                Text(entry.formula)
                    .font(AppTypography.caption)
                    .fontDesign(.monospaced)
                    .foregroundStyle(AppTheme.sectionSubtitle)
            }
            Spacer()
            Button {
                favoritesManager.toggle(entry.id)
            } label: {
                Image(systemName: favoritesManager.isFavorite(entry.id) ? "star.fill" : "star")
                    .font(.system(size: 18))
                    .foregroundStyle(favoritesManager.isFavorite(entry.id) ? AppTheme.Category.success : AppTheme.sectionSubtitle)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(favoritesManager.isFavorite(entry.id) ? "Remove from favorites" : "Add to favorites")
        }
        .padding(16)
        .cardStyle(cornerRadius: 14, hasShadow: true)
    }
}

// MARK: - Favorite Chip
struct FavoriteChip: View {
    let entry: FormulaEntry
    
    var body: some View {
        HStack(spacing: 6) {
            Text(entry.name)
                .font(AppTypography.subtitle)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.accent)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(AppTheme.accentLight)
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(AppTheme.accent.opacity(0.4), lineWidth: 1)
        )
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
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppTheme.Category.success)
                .frame(width: 48, height: 48)
                .background(AppTheme.Category.success.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppTheme.sectionSubtitle)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 22))
                .foregroundStyle(AppTheme.Category.success)
        }
        .padding(16)
        .cardStyle(cornerRadius: 16, hasShadow: true)
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
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(AppTheme.Category.comingSoon)
                .frame(width: 48, height: 48)
                .background(AppTheme.Category.comingSoon.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppTheme.sectionSubtitle)
                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppTheme.Category.comingSoon)
            }
            
            Spacer()
        }
        .padding(16)
        .background(AppTheme.cardBackground.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Feature Card
struct FeatureCard: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    var accent: Color = AppTheme.accent
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(accent)
                .frame(width: 48, height: 48)
                .background(accent.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(.primary)
                
                if let subtitle {
                    Text(subtitle)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppTheme.sectionSubtitle)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(accent.opacity(0.8))
        }
        .padding(16)
        .cardStyle(cornerRadius: 16, hasShadow: true)
    }
}

#Preview {
    HomeView()
        .environment(HistoryManager.shared)
        .environment(FavoritesManager.shared)
        .environment(SpotlightRouter())
}
