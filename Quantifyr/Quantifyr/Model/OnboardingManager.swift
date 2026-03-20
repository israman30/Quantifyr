//
//  OnboardingManager.swift
//  Quantifyr
//
//  Tracks first launch and whether onboarding has been completed.
//

import Foundation

@Observable
final class OnboardingManager {
    static let shared = OnboardingManager()
    
    private let key = "quantifyr_onboarding_completed"
    
    /// True if the user has completed onboarding (or skipped it).
    var hasCompletedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: key) }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
    /// True on first install before onboarding is completed.
    var isFirstLaunch: Bool {
        !hasCompletedOnboarding
    }
    
    private init() {}
    
    func markOnboardingCompleted() {
        hasCompletedOnboarding = true
    }
}
