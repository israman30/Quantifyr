//
//  FormulaLibrary.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/14/26.
//

import SwiftUI

/// Formula library item for dynamic UI rendering.
/// Maps to FormulaRegistry entries for navigation.
struct FormulaLibraryItem: Identifiable {
    let id: String
    let name: String
    let formula: String
    let icon: String
}

/// Central formula library supporting 50+ formulas.
/// Categories drive dynamic UI in ElectricalView, PhysicsView, etc.
struct FormulaLibrary {
    
    static let electrical: [FormulaLibraryItem] = [
        FormulaLibraryItem(id: "ohms_law", name: "Ohm's Law", formula: "V = I × R", icon: "bolt.fill"),
        FormulaLibraryItem(id: "power", name: "Power Law", formula: "P = V × I", icon: "gauge.with.dots.needle.67percent"),
        FormulaLibraryItem(id: "resistor", name: "Resistor Series/Parallel", formula: "R_total = R₁+R₂+... or 1/R₁+1/R₂+...", icon: "rectangle.3.group"),
        FormulaLibraryItem(id: "capacitance", name: "Capacitance", formula: "Q = CV", icon: "capacitor.fill")
    ]
    
    static let physics: [FormulaLibraryItem] = [
        FormulaLibraryItem(id: "force", name: "Force", formula: "F = m × a", icon: "arrow.up.and.down.and.arrow.left.and.right"),
        FormulaLibraryItem(id: "momentum", name: "Momentum", formula: "p = mv", icon: "arrow.forward"),
        FormulaLibraryItem(id: "kinetic_energy", name: "Energy", formula: "E = ½mv²", icon: "bolt.fill"),
        FormulaLibraryItem(id: "velocity", name: "Velocity", formula: "v = d / t", icon: "speedometer")
    ]
    
    static let frequency: [FormulaLibraryItem] = [
        FormulaLibraryItem(id: "wavelength", name: "Wavelength", formula: "λ = v / f", icon: "waveform.path"),
        FormulaLibraryItem(id: "rc_filter", name: "RC Filter", formula: "f = 1 / (2πRC)", icon: "waveform.circle")
    ]
    
    static let math: [FormulaLibraryItem] = [
        FormulaLibraryItem(id: "metric_prefix", name: "Metric Prefix", formula: "kilo, mega, giga, milli, micro", icon: "number")
    ]
    
    /// All unique formula IDs across categories (deduplicated for search).
    static var allItems: [FormulaLibraryItem] {
        var seen = Set<String>()
        return (electrical + physics + frequency + math).filter { seen.insert($0.id).inserted }
    }
}
