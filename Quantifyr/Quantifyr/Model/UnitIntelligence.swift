//
//  UnitIntelligence.swift
//  Quantifyr
//
//  Smart unit suggestions: 1000 m → 1 km, 1000 g → 1 kg
//

import Foundation

/// Suggests cleaner unit representations when the result is a "round" number in another unit.
struct UnitIntelligence {
    
    private static let epsilon = 1e-9
    
    /// A smart suggestion: "1 km" instead of "1000 m"
    struct Suggestion: Equatable {
        let value: Double
        let unit: String
        let message: String  // e.g., "Cleaner: 1 km"
    }
    
    /// Returns a suggestion when the result could be expressed more cleanly.
    static func suggest(
        result: Double,
        resultUnit: String,
        category: ConversionCategory
    ) -> Suggestion? {
        switch category {
        case .length:
            return suggestLength(result: result, unit: resultUnit)
        case .weight:
            return suggestWeight(result: result, unit: resultUnit)
        case .speed:
            return suggestSpeed(result: result, unit: resultUnit)
        case .energy:
            return suggestEnergy(result: result, unit: resultUnit)
        case .temperature:
            return nil  // Temperature rarely has "cleaner" forms
        }
    }
    
    // MARK: - Length (m, ft, km, mi)
    private static func suggestLength(result: Double, unit: String) -> Suggestion? {
        let units = ["m", "ft", "km", "mi"]
        guard let idx = units.firstIndex(of: unit) else { return nil }
        
        // 1000 m → 1 km (and 1000000 m → 1000 km, etc.)
        if idx == 0, result >= 999.9 {
            let km = result / 1000
            if isRound(km) { return Suggestion(value: km, unit: "km", message: "Cleaner: \(format(km)) km") }
        }
        // 0.001 km → 1 m
        if idx == 2, result > 0, result < 1 {
            let m = result * 1000
            if isRound(m) { return Suggestion(value: m, unit: "m", message: "Cleaner: \(format(m)) m") }
        }
        // 5280 ft → 1 mi
        if idx == 1, result >= 5279 {
            let mi = result / 5280
            if isRound(mi) { return Suggestion(value: mi, unit: "mi", message: "Cleaner: \(format(mi)) mi") }
        }
        // 0.000189 mi → 1 ft (1/5280)
        if idx == 3, result > 0, result < 0.01 {
            let ft = result * 5280
            if isRound(ft), ft >= 1 { return Suggestion(value: ft, unit: "ft", message: "Cleaner: \(format(ft)) ft") }
        }
        return nil
    }
    
    // MARK: - Weight (kg, lb, g, oz)
    private static func suggestWeight(result: Double, unit: String) -> Suggestion? {
        let units = ["kg", "lb", "g", "oz"]
        guard let idx = units.firstIndex(of: unit) else { return nil }
        
        // 1000 g → 1 kg
        if idx == 2, result >= 999.9 {
            let kg = result / 1000
            if isRound(kg) { return Suggestion(value: kg, unit: "kg", message: "Cleaner: \(format(kg)) kg") }
        }
        // 0.001 kg → 1 g
        if idx == 0, result > 0, result < 1 {
            let g = result * 1000
            if isRound(g) { return Suggestion(value: g, unit: "g", message: "Cleaner: \(format(g)) g") }
        }
        return nil
    }
    
    // MARK: - Speed (km/h, mph)
    private static func suggestSpeed(result: Double, unit: String) -> Suggestion? {
        return nil
    }
    
    // MARK: - Energy (J, cal)
    private static func suggestEnergy(result: Double, unit: String) -> Suggestion? {
        return nil
    }
    
    private static func isRound(_ v: Double) -> Bool {
        abs(v - round(v)) < epsilon
    }
    
    private static func format(_ v: Double) -> String {
        if abs(v - round(v)) < epsilon { return String(Int(round(v))) }
        return String(format: "%.4g", v)
    }
}
