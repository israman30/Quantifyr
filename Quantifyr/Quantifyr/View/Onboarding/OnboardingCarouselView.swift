//
//  OnboardingCarouselView.swift
//  Quantifyr
//
//  Tutorial carousel shown on first launch or from settings.
//

import SwiftUI

// MARK: - Onboarding Page Model
struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let accent: Color
}

// MARK: - Onboarding Carousel View
struct OnboardingCarouselView: View {
    let isFirstLaunch: Bool
    let onComplete: () -> Void
    
    @State private var currentPage = 0
    
    private static let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to Quantifyr",
            subtitle: "Your scientific calculator and formula toolkit. Solve physics, electrical, math, and more—instantly.",
            icon: "function",
            accent: AppTheme.accent
        ),
        OnboardingPage(
            title: "Browse & Search",
            subtitle: "Explore formulas by category or search by name. Star favorites for quick access from the home screen.",
            icon: "magnifyingglass",
            accent: AppTheme.Category.unitConverter
        ),
        OnboardingPage(
            title: "Enter & Calculate",
            subtitle: "Pick what to solve for, enter known values, and tap Calculate. Get results with optional step-by-step solutions.",
            icon: "equal.circle.fill",
            accent: AppTheme.Category.electrical
        ),
        OnboardingPage(
            title: "Smart Features",
            subtitle: "Unit intelligence, formula visualizer, graph equations, and Spotlight search. Your calculations stay in history.",
            icon: "lightbulb.fill",
            accent: AppTheme.Category.math
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip button (first launch only)
                if isFirstLaunch {
                    HStack {
                        Spacer()
                        Button("Skip") {
                            complete()
                        }
                        .font(AppTypography.subtitle)
                        .foregroundStyle(AppTheme.sectionSubtitle)
                        .padding(.horizontal, Spacing.m)
                        .padding(.top, Spacing.m)
                    }
                }
                
                TabView(selection: $currentPage) {
                    ForEach(Array(Self.pages.enumerated()), id: \.element.id) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<Self.pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppTheme.accent : AppTheme.sectionSubtitle.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, Spacing.l)
                
                // Action button
                Button {
                    if currentPage < Self.pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            currentPage += 1
                        }
                    } else {
                        complete()
                    }
                } label: {
                    Text(currentPage < Self.pages.count - 1 ? "Next" : (isFirstLaunch ? "Get Started" : "Done"))
                        .font(AppTypography.section)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.m)
                        .background(AppTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, Spacing.l)
                .padding(.bottom, Spacing.l + 20)
            }
        }
    }
    
    private func complete() {
        if isFirstLaunch {
            OnboardingManager.shared.markOnboardingCompleted()
        }
        onComplete()
    }
}

// MARK: - Single Page View
private struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: Spacing.l) {
            Spacer()
            
            Image(systemName: page.icon)
                .font(.system(size: 64, weight: .medium))
                .foregroundStyle(page.accent)
                .frame(width: 120, height: 120)
                .background(page.accent.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            
            VStack(spacing: Spacing.m) {
                Text(page.title)
                    .font(AppTypography.title)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(AppTypography.body)
                    .foregroundStyle(AppTheme.sectionSubtitle)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, Spacing.l)
            
            Spacer()
        }
    }
}

// MARK: - Static Tutorial View (for Settings access)
struct OnboardingTutorialView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            OnboardingCarouselView(isFirstLaunch: false) {
                dismiss()
            }
            .navigationTitle("How Quantifyr Works")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(AppTheme.accent)
                }
            }
        }
    }
}

#Preview("First Launch") {
    OnboardingCarouselView(isFirstLaunch: true) {}
}

#Preview("From Settings") {
    OnboardingTutorialView()
}
