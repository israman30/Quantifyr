//
//  DesignSystem.swift
//  Quantifyr
//
//  Apple-level design system: clarity, depth & layering, typography hierarchy.
//

import SwiftUI

// MARK: - Spacing System
enum Spacing {
    static let s: CGFloat = 8
    static let m: CGFloat = 16
    static let l: CGFloat = 24
}

// MARK: - Color System (Semantic)
enum AppColors {
    static let background = Color(.systemGroupedBackground)
    static let card = Color(.secondarySystemGroupedBackground)
    
    static let electrical = Color.orange
    static let physics = Color.blue
    static let math = Color.green
    static let frequency = Color.purple
}

// MARK: - Typography Hierarchy
enum AppTypography {
    /// Large titles for context (34pt)
    static let title = Font.system(size: 34, weight: .bold)
    
    /// Section headers (20pt)
    static let section = Font.system(size: 20, weight: .semibold)
    
    /// Body text (16pt)
    static let body = Font.system(size: 16)
    
    /// Monospaced for calculations (28pt)
    static let number = Font.system(size: 28, weight: .medium, design: .monospaced)
    
    /// Large display for calculator results (36pt)
    static let displayNumber = Font.system(size: 36, weight: .semibold, design: .monospaced)
    
    // MARK: - Legacy (backward compatibility)
    static let largeTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    static let sectionTitle = Font.system(size: 20, weight: .semibold)
    static let cardTitle = Font.system(size: 17, weight: .semibold)
    static let subtitle = Font.system(size: 15, weight: .regular)
    static let caption = Font.system(size: 13, weight: .regular)
    static let caption2 = Font.system(size: 12, weight: .medium)
}

// MARK: - App Theme (extends AppColors, backward compatible)
enum AppTheme {
    static let accent = Color(red: 0.05, green: 0.58, blue: 0.53)
    static let accentLight = Color(red: 0.05, green: 0.58, blue: 0.53).opacity(0.15)
    
    enum Category {
        static let unitConverter = Color(red: 0.20, green: 0.47, blue: 0.86)
        static let electrical = AppColors.electrical
        static let physics = AppColors.physics
        static let frequency = AppColors.frequency
        static let math = AppColors.math
        static let success = Color(red: 0.18, green: 0.64, blue: 0.38)
        static let comingSoon = Color(red: 0.45, green: 0.45, blue: 0.48)
    }
    
    static let cardBackground = AppColors.card
    static let cardShadow = Color.black.opacity(0.06)
    static let sectionTitle = Color.primary
    static let sectionSubtitle = Color.secondary
}

// MARK: - View Modifiers (Depth & layering: materials, soft shadows)
struct CardStyle: ViewModifier {
    var cornerRadius: CGFloat = 16
    var hasShadow: Bool = true
    var useMaterial: Bool = true
    
    func body(content: Content) -> some View {
        content
            .background {
                if useMaterial {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(AppTheme.cardBackground)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: AppTheme.cardShadow, radius: hasShadow ? 6 : 0, x: 0, y: 2)
    }
}

struct SectionHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppTypography.section)
            .foregroundStyle(AppTheme.sectionTitle)
    }
}

extension View {
    func cardStyle(cornerRadius: CGFloat = 16, hasShadow: Bool = true, useMaterial: Bool = true) -> some View {
        modifier(CardStyle(cornerRadius: cornerRadius, hasShadow: hasShadow, useMaterial: useMaterial))
    }
}
