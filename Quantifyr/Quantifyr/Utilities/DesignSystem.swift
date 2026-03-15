//
//  DesignSystem.swift
//  Quantifyr
//
//  Design system for accessible, attractive UI with high contrast.
//

import SwiftUI

// MARK: - App Theme
enum AppTheme {
    /// Primary accent - teal, scientific feel, WCAG AA compliant
    static let accent = Color(red: 0.05, green: 0.58, blue: 0.53)
    static let accentLight = Color(red: 0.05, green: 0.58, blue: 0.53).opacity(0.15)
    
    /// Category-specific accents for visual hierarchy (all WCAG compliant)
    enum Category {
        static let unitConverter = Color(red: 0.20, green: 0.47, blue: 0.86)      // Blue
        static let electrical = Color(red: 0.95, green: 0.55, blue: 0.14)         // Amber
        static let physics = Color(red: 0.91, green: 0.30, blue: 0.24)            // Coral
        static let frequency = Color(red: 0.56, green: 0.27, blue: 0.68)          // Purple
        static let math = Color(red: 0.13, green: 0.59, blue: 0.55)              // Teal
        static let success = Color(red: 0.18, green: 0.64, blue: 0.38)           // Green
        static let comingSoon = Color(red: 0.45, green: 0.45, blue: 0.48)        // Gray
    }
    
    /// Card styling
    static let cardBackground = Color(.secondarySystemGroupedBackground)
    static let cardShadow = Color.black.opacity(0.06)
    
    /// Section header - high contrast
    static let sectionTitle = Color.primary
    static let sectionSubtitle = Color.secondary
}

// MARK: - Typography (Accessible font sizes)
enum AppTypography {
    /// Large title - 28pt for main headings
    static let largeTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    
    /// Section headers - 17pt semibold for clear hierarchy
    static let sectionTitle = Font.system(size: 17, weight: .semibold)
    
    /// Card title - 17pt for readability
    static let cardTitle = Font.system(size: 17, weight: .semibold)
    
    /// Body - 16pt minimum for accessibility
    static let body = Font.system(size: 16, weight: .regular)
    
    /// Subtitle - 15pt
    static let subtitle = Font.system(size: 15, weight: .regular)
    
    /// Caption - 13pt (above 12pt minimum for legibility)
    static let caption = Font.system(size: 13, weight: .regular)
    
    /// Small caption
    static let caption2 = Font.system(size: 12, weight: .medium)
}

// MARK: - View Modifiers
struct CardStyle: ViewModifier {
    var cornerRadius: CGFloat = 16
    var hasShadow: Bool = true
    
    func body(content: Content) -> some View {
        content
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: AppTheme.cardShadow, radius: hasShadow ? 8 : 0, x: 0, y: 2)
    }
}

struct SectionHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppTypography.sectionTitle)
            .foregroundStyle(AppTheme.sectionTitle)
    }
}

extension View {
    func cardStyle(cornerRadius: CGFloat = 16, hasShadow: Bool = true) -> some View {
        modifier(CardStyle(cornerRadius: cornerRadius, hasShadow: hasShadow))
    }
}
