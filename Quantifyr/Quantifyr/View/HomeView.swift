//
//  HomeView.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

// MARK: - Home View
enum CategoryLayout: String, CaseIterable {
    case grid = "square.grid.2x2"
    case list = "list.bullet"
}

struct HomeView: View {
    @Environment(HistoryManager.self) private var historyManager
    @Environment(FavoritesManager.self) private var favoritesManager
    @EnvironmentObject private var coordinator: Coordinator
    @State private var searchText = ""
    @State private var categoryLayout: CategoryLayout = .grid
    
    private var searchResults: [FormulaEntry] {
        FormulaRegistry.search(searchText)
    }
    
    private var favoriteEntries: [FormulaEntry] {
        FormulaRegistry.favorites(favoritesManager.favoriteIds)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.l) {
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
                
                // App version & copyright
                appFooter
            }
            .padding(.vertical, Spacing.l)
            .padding(.horizontal, Spacing.m)
        }
        .background(AppColors.background)
        .navigationTitle("Quantifyr")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Picker("Layout", selection: $categoryLayout) {
                        Label("Grid", systemImage: "square.grid.2x2")
                            .tag(CategoryLayout.grid)
                        Label("List", systemImage: "list.bullet")
                            .tag(CategoryLayout.list)
                    }
                    .pickerStyle(.inline)
                    Divider()
                    Button {
                        coordinator.sheet = .onboarding
                    } label: {
                        Label("How it works", systemImage: "questionmark.circle")
                    }
                } label: {
                    Image(systemName: categoryLayout == .grid ? "square.grid.2x2" : "list.bullet")
                        .font(.system(size: 16, weight: .medium))
                }
                .accessibilityLabel("Toggle grid or list layout")
            }
        }
        .searchable(text: $searchText, prompt: "Search formulas: voltage, force, frequency...")
    }
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
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
                        Button {
                            coordinator.push(.formula(id: entry.id))
                        } label: {
                            FormulaSearchRow(entry: entry)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private var recentCalculationsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
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
                    .padding(.vertical, Spacing.m)
                    .padding(.horizontal, Spacing.m)
                    
                    if record.id != historyManager.records.prefix(10).last?.id {
                        Divider()
                            .padding(.leading, Spacing.m)
                    }
                }
            }
            .cardStyle(cornerRadius: 14, hasShadow: true)
        }
    }
    
    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Favorites")
                .font(AppTypography.sectionTitle)
                .foregroundStyle(AppTheme.sectionTitle)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(favoriteEntries) { entry in
                        Button {
                            coordinator.push(.formula(id: entry.id))
                        } label: {
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
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Scientific Toolkit")
                .font(AppTypography.sectionTitle)
                .foregroundStyle(AppTheme.sectionTitle)
            
            Text("Enter known values → get results instantly")
                .font(AppTypography.subtitle)
                .foregroundStyle(AppTheme.sectionSubtitle)
                .padding(.bottom, 6)
            
                if categoryLayout == .grid {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: Spacing.m),
                    GridItem(.flexible(), spacing: Spacing.m)
                ], spacing: Spacing.m) {
                    CategoryCardLink(
                        title: "Unit Converter",
                        subtitle: "Length, weight, temperature, speed, energy",
                        icon: "arrow.left.arrow.right",
                        accent: AppTheme.Category.unitConverter,
                        compact: true,
                        page: .unitConverter
                    )
                    CategoryCardLink(
                        title: "Electrical",
                        subtitle: "Ohm's Law, Power, Energy, Resistors, Capacitors, RC",
                        icon: "bolt.fill",
                        accent: AppTheme.Category.electrical,
                        compact: true,
                        page: .electrical
                    )
                    CategoryCardLink(
                        title: "Physics",
                        subtitle: "Force, Energy, Velocity, Density, Pressure, Work",
                        icon: "atom",
                        accent: AppTheme.Category.physics,
                        compact: true,
                        page: .physics
                    )
                    CategoryCardLink(
                        title: "Frequency",
                        subtitle: "Wave speed, Frequency, Period, Reactance",
                        icon: "waveform",
                        accent: AppTheme.Category.frequency,
                        compact: true,
                        page: .frequency
                    )
                    CategoryCardLink(
                        title: "Math",
                        subtitle: "Slope, Quadratic, Area, Volume, Pythagorean",
                        icon: "number",
                        accent: AppTheme.Category.math,
                        compact: true,
                        page: .math
                    )
                    CategoryCardLink(
                        title: "Calculator",
                        subtitle: "TI-84 style: sin, cos, log, π, PEMDAS",
                        icon: "function",
                        accent: AppTheme.Category.math,
                        compact: true,
                        page: .calculator
                    )
                    CategoryCardLink(
                        title: "Graph Equations",
                        subtitle: "Plot y = f(x): x², sin(x), 2x+1",
                        icon: "chart.line.uptrend.xyaxis",
                        accent: AppTheme.Category.math,
                        compact: true,
                        page: .graph
                    )
                    CategoryCardLink(
                        title: "Constants",
                        subtitle: "π, c, G, h, ε₀, Avogadro, and more",
                        icon: "square.stack.3d.up",
                        accent: AppTheme.Category.physics,
                        compact: true,
                        page: .constants
                    )
                }
            } else {
                VStack(spacing: Spacing.m) {
                    CategoryCardLink(
                        title: "Unit Converter",
                        subtitle: "Length, weight, temperature, speed, energy",
                        icon: "arrow.left.arrow.right",
                        accent: AppTheme.Category.unitConverter,
                        page: .unitConverter
                    )
                    CategoryCardLink(
                        title: "Electrical",
                        subtitle: "Ohm's Law, Power, Energy, Resistors, Capacitors, RC",
                        icon: "bolt.fill",
                        accent: AppTheme.Category.electrical,
                        page: .electrical
                    )
                    CategoryCardLink(
                        title: "Physics",
                        subtitle: "Force, Energy, Velocity, Density, Pressure, Work",
                        icon: "atom",
                        accent: AppTheme.Category.physics,
                        page: .physics
                    )
                    CategoryCardLink(
                        title: "Frequency",
                        subtitle: "Wave speed, Frequency, Period, Reactance",
                        icon: "waveform",
                        accent: AppTheme.Category.frequency,
                        page: .frequency
                    )
                    CategoryCardLink(
                        title: "Math",
                        subtitle: "Slope, Quadratic, Area, Volume, Pythagorean",
                        icon: "number",
                        accent: AppTheme.Category.math,
                        page: .math
                    )
                    CategoryCardLink(
                        title: "Calculator",
                        subtitle: "TI-84 style: sin, cos, log, π, PEMDAS",
                        icon: "function",
                        accent: AppTheme.Category.math,
                        page: .calculator
                    )
                    CategoryCardLink(
                        title: "Graph Equations",
                        subtitle: "Plot y = f(x): x², sin(x), 2x+1",
                        icon: "chart.line.uptrend.xyaxis",
                        accent: AppTheme.Category.math,
                        page: .graph
                    )
                    CategoryCardLink(
                        title: "Constants",
                        subtitle: "π, c, G, h, ε₀, Avogadro, and more",
                        icon: "square.stack.3d.up",
                        accent: AppTheme.Category.physics,
                        page: .constants
                    )
                }
            }
            
            // Advanced Features (Future Versions)
            advancedFeaturesSection
        }
    }
    
    private var advancedFeaturesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Advanced Features")
                .font(AppTypography.sectionTitle)
                .foregroundStyle(AppTheme.sectionTitle)
            
            Text("Professional tools for students")
                .font(AppTypography.subtitle)
                .foregroundStyle(AppTheme.sectionSubtitle)
                .padding(.bottom, 6)
            
            VStack(spacing: Spacing.m) {
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
    
    private var appFooter: some View {
        HStack(spacing: 4) {
            Text("Version \(Bundle.main.appVersion)")
                .font(AppTypography.caption2)
                .foregroundStyle(AppTheme.sectionSubtitle)
            Text("2026©")
                .font(AppTypography.caption2)
                .foregroundStyle(AppTheme.sectionSubtitle)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Spacing.l)
    }
}

// MARK: - Bundle Extension
private extension Bundle {
    var appVersion: String {
        (infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0"
    }
}

// MARK: - Category Card Link
struct CategoryCardLink: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    var accent: Color = AppTheme.accent
    var compact: Bool = false
    let page: Pages
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        Button {
            coordinator.push(page)
        } label: {
            FeatureCard(title: title, subtitle: subtitle, icon: icon, accent: accent, compact: compact)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Formula Search Row
struct FormulaSearchRow: View {
    let entry: FormulaEntry
    @Environment(FavoritesManager.self) private var favoritesManager
    
    var body: some View {
        HStack(spacing: Spacing.m) {
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
        .padding(Spacing.m)
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
        .padding(.horizontal, Spacing.l)
        .padding(.vertical, Spacing.m)
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
        HStack(spacing: Spacing.m) {
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
        .padding(Spacing.m)
        .cardStyle(cornerRadius: 16, hasShadow: true)
    }
}

// MARK: - Future Feature Card
struct FutureFeatureCard: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: Spacing.m) {
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
        .padding(Spacing.m)
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
    var compact: Bool = false
    
    var body: some View {
        Group {
            if compact {
                compactContent
            } else {
                listContent
            }
        }
        .cardStyle(cornerRadius: 16, hasShadow: true)
    }
    
    private var listContent: some View {
        HStack(spacing: Spacing.m) {
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
        .padding(Spacing.m)
    }
    
    private var compactContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(accent)
                .frame(width: 44, height: 44)
                .background(accent.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTypography.subtitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                if let subtitle {
                    Text(subtitle)
                        .font(AppTypography.caption2)
                        .foregroundStyle(AppTheme.sectionSubtitle)
                        .lineLimit(2)
                }
            }
            
            Spacer(minLength: 0)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(accent.opacity(0.8))
        }
        .padding(Spacing.m)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HomeView()
        .environment(HistoryManager.shared)
        .environment(FavoritesManager.shared)
        .environment(SpotlightRouter())
        .environmentObject(Coordinator())
}
