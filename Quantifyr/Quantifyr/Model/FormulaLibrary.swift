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
    
    /// Wave & Frequency formulas — organized for students
    static let frequency: [FormulaLibraryItem] = [
        FormulaLibraryItem(id: "wave_speed", name: "Wave Speed", formula: "v = fλ", icon: "waveform.path"),
        FormulaLibraryItem(id: "frequency_period", name: "Frequency", formula: "f = 1 / T", icon: "waveform"),
        FormulaLibraryItem(id: "frequency_period", name: "Period", formula: "T = 1 / f", icon: "clock"),
        FormulaLibraryItem(id: "angular_frequency", name: "Angular Frequency", formula: "ω = 2πf", icon: "arrow.triangle.2.circlepath"),
        FormulaLibraryItem(id: "wavelength", name: "Wavelength", formula: "λ = v / f", icon: "waveform.path"),
        FormulaLibraryItem(id: "rc_filter", name: "RC Filter Frequency", formula: "f = 1 / (2πRC)", icon: "waveform.circle"),
        FormulaLibraryItem(id: "inductive_reactance", name: "Inductive Reactance", formula: "Xₗ = 2πfL", icon: "rectangle.3.group"),
        FormulaLibraryItem(id: "capacitive_reactance", name: "Capacitive Reactance", formula: "Xc = 1 / (2πfC)", icon: "selection.pin.in.out")
    ]
    
    /// Mathematics formulas — organized for students
    static let math: [FormulaLibraryItem] = [
        FormulaLibraryItem(id: "slope", name: "Slope", formula: "m = (y₂ - y₁)/(x₂ - x₁)", icon: "line.diagonal"),
        FormulaLibraryItem(id: "quadratic_formula", name: "Quadratic Formula", formula: "x = (-b ± √(b²-4ac)) / 2a", icon: "x.squareroot"),
        FormulaLibraryItem(id: "area_circle", name: "Area Circle", formula: "A = πr²", icon: "circle.fill"),
        FormulaLibraryItem(id: "circumference", name: "Circumference", formula: "C = 2πr", icon: "circle"),
        FormulaLibraryItem(id: "area_triangle", name: "Area Triangle", formula: "A = ½bh", icon: "triangle.fill"),
        FormulaLibraryItem(id: "pythagorean", name: "Pythagorean", formula: "a² + b² = c²", icon: "square"),
        FormulaLibraryItem(id: "volume_sphere", name: "Volume Sphere", formula: "V = 4/3 πr³", icon: "circle.circle"),
        FormulaLibraryItem(id: "volume_cylinder", name: "Volume Cylinder", formula: "V = πr²h", icon: "cylinder.fill"),
        FormulaLibraryItem(id: "average", name: "Average", formula: "mean = Σx / n", icon: "number"),
        FormulaLibraryItem(id: "metric_prefix", name: "Metric Prefix", formula: "kilo, mega, giga, milli, micro", icon: "number")
    ]
    
    /// All unique formula IDs across categories (deduplicated for search).
    static var allItems: [FormulaLibraryItem] {
        var seen = Set<String>()
        return (electrical + physics + frequency + math).filter { seen.insert($0.id).inserted }
    }
}
