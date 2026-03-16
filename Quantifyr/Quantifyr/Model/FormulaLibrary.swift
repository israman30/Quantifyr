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
    
    /// Electrical Engineering formulas — organized for students
    static let electrical: [FormulaLibraryItem] = [
        // Ohm's Law and variants
        FormulaLibraryItem(id: "ohms_law", name: "Ohm's Law", formula: "V = I × R", icon: "bolt.fill"),
        FormulaLibraryItem(id: "ohms_law", name: "Current", formula: "I = V / R", icon: "arrow.right"),
        FormulaLibraryItem(id: "ohms_law", name: "Resistance", formula: "R = V / I", icon: "rectangle.3.group"),
        // Power and Energy
        FormulaLibraryItem(id: "power", name: "Electrical Power", formula: "P = V × I", icon: "gauge.with.dots.needle.67percent"),
        FormulaLibraryItem(id: "power", name: "Power (Current form)", formula: "P = I²R", icon: "gauge.with.dots.needle.67percent"),
        FormulaLibraryItem(id: "power", name: "Power (Voltage form)", formula: "P = V² / R", icon: "gauge.with.dots.needle.67percent"),
        FormulaLibraryItem(id: "power", name: "Energy", formula: "E = P × t", icon: "bolt.circle"),
        // Resistors
        FormulaLibraryItem(id: "resistor", name: "Series Resistance", formula: "R_total = R₁ + R₂ + ...", icon: "rectangle.3.group"),
        FormulaLibraryItem(id: "resistor", name: "Parallel Resistance", formula: "1/R = 1/R₁ + 1/R₂", icon: "rectangle.3.group"),
        // Capacitors
        FormulaLibraryItem(id: "capacitance", name: "Capacitor Energy", formula: "E = ½ C V²", icon: "bolt.fill"),
        FormulaLibraryItem(id: "capacitance", name: "Capacitor Charge", formula: "Q = C × V", icon: "selection.pin.in.out"),
        // RC circuits
        FormulaLibraryItem(id: "rc_filter", name: "RC Time Constant", formula: "τ = R × C", icon: "waveform.circle")
    ]
    
    /// Physics formulas — organized for students
    static let physics: [FormulaLibraryItem] = [
        FormulaLibraryItem(id: "force", name: "Force", formula: "F = m × a", icon: "arrow.up.and.down.and.arrow.left.and.right"),
        FormulaLibraryItem(id: "momentum", name: "Momentum", formula: "p = m × v", icon: "arrow.forward"),
        FormulaLibraryItem(id: "kinetic_energy", name: "Kinetic Energy", formula: "KE = ½mv²", icon: "bolt.fill"),
        FormulaLibraryItem(id: "potential_energy", name: "Potential Energy", formula: "PE = mgh", icon: "arrow.down.to.line"),
        FormulaLibraryItem(id: "velocity", name: "Velocity", formula: "v = d / t", icon: "speedometer"),
        FormulaLibraryItem(id: "acceleration", name: "Acceleration", formula: "a = Δv / t", icon: "arrow.up.forward"),
        FormulaLibraryItem(id: "density", name: "Density", formula: "ρ = m / V", icon: "drop.fill"),
        FormulaLibraryItem(id: "pressure", name: "Pressure", formula: "P = F / A", icon: "square.on.square"),
        FormulaLibraryItem(id: "work", name: "Work", formula: "W = F × d", icon: "wrench.and.screwdriver"),
        FormulaLibraryItem(id: "physics_power", name: "Power", formula: "P = W / t", icon: "gauge.with.dots.needle.67percent"),
        FormulaLibraryItem(id: "centripetal_force", name: "Centripetal Force", formula: "F = mv² / r", icon: "arrow.triangle.2.circlepath"),
        FormulaLibraryItem(id: "gravitational_force", name: "Gravitational Force", formula: "F = G(m₁m₂)/r²", icon: "globe.americas.fill")
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
