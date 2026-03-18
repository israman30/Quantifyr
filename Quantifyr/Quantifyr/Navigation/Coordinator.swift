//
//  Coordinator.swift
//  Quantifyr
//
//  Coordinator-based navigation pattern.
//

import SwiftUI
import Combine

// MARK: - Pages
enum Pages: Hashable, Identifiable {
    case main
    case unitConverter
    case electrical
    case physics
    case frequency
    case math
    case calculator
    case graph
    case constants
    case formula(id: String)
    
    var id: String {
        UUID().uuidString
    }
}

// MARK: - Sheet Pages (for modal presentation)
enum SheetPage: Identifiable {
    case placeholder
    case onboarding
    var id: String {
        switch self {
        case .placeholder: return "placeholder"
        case .onboarding: return "onboarding"
        }
    }
}

// MARK: - Coordinator
final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: SheetPage?
    @Published var fullScreenSheet: SheetPage?
    
    func push(_ page: Pages) {
        path.append(page)
    }
    
    func dismiss() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    @ViewBuilder
    func build(_ page: Pages) -> some View {
        switch page {
        case .main:
            RootTabView()
        case .unitConverter:
            UnitConverterView()
        case .electrical:
            ElectricalView()
        case .physics:
            PhysicsView()
        case .frequency:
            FrequencyView()
        case .math:
            MathView()
        case .calculator:
            CalculatorView()
        case .graph:
            GraphView()
        case .constants:
            ConstantsView()
        case .formula(let id):
            FormulaRegistry.destination(for: id)
        }
    }
}

// MARK: - Coordinator View
struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    @Environment(SpotlightRouter.self) private var spotlightRouter
    
    var body: some View {
        TabView {
            NavigationStack(path: $coordinator.path) {
                HomeView()
                    .navigationDestination(for: Pages.self) { page in
                        coordinator.build(page)
                    }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationStack {
                UnitConverterView()
            }
            .tabItem {
                Label("Units", systemImage: "arrow.left.arrow.right")
            }
        }
        .sheet(item: $coordinator.sheet) { sheet in
            coordinator.build(sheet)
        }
        .fullScreenCover(item: $coordinator.fullScreenSheet) { fullScreenSheet in
            coordinator.build(fullScreenSheet)
        }
        .onAppear {
            if let id = spotlightRouter.consumePendingNavigation() {
                coordinator.push(.formula(id: id))
            }
        }
        .onChange(of: spotlightRouter.formulaIdToOpen) { _, _ in
            if let id = spotlightRouter.consumePendingNavigation() {
                coordinator.push(.formula(id: id))
            }
        }
        .environmentObject(coordinator)
    }
}

// MARK: - Coordinator build for SheetPage
extension Coordinator {
    @ViewBuilder
    func build(_ sheet: SheetPage) -> some View {
        switch sheet {
        case .placeholder:
            EmptyView()
        case .onboarding:
            OnboardingTutorialView()
        }
    }
}

#Preview {
    CoordinatorView()
        .environment(HistoryManager.shared)
        .environment(FavoritesManager.shared)
        .environment(SpotlightRouter())
}
