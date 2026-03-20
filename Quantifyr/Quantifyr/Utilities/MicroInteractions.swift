//
//  MicroInteractions.swift
//  Quantifyr
//
//  Premium micro-interactions: haptics, press animations, smooth transitions.
//

import SwiftUI

// MARK: - Haptic Feedback
enum HapticFeedback {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

// MARK: - Calculate Button Style (haptic + press animation)
struct CalculateButtonStyle: ButtonStyle {
    var isEnabled: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed && isEnabled ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .opacity(isEnabled ? 1 : 0.6)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(AppTheme.accent)
            )
            .background(
                HapticOnPressView(isPressed: configuration.isPressed, isEnabled: isEnabled)
            )
    }
}

private struct HapticOnPressView: View {
    let isPressed: Bool
    let isEnabled: Bool
    @State private var lastPressed = false
    
    var body: some View {
        Color.clear
            .onChange(of: isPressed) { _, new in
                if new && isEnabled && !lastPressed {
                    HapticFeedback.impact(.medium)
                }
                lastPressed = new
            }
    }
}

// MARK: - Scale Press Button Style (for cards, chips)
struct ScalePressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Active Input Highlight
struct ActiveInputModifier: ViewModifier {
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(isActive ? AppTheme.accent : Color.clear, lineWidth: 2)
                    .padding(1)
            )
            .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

extension View {
    func activeInputHighlight(_ isActive: Bool) -> some View {
        modifier(ActiveInputModifier(isActive: isActive))
    }
}
