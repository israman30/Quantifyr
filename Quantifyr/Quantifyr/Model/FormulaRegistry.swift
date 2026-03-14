//
//  FormulaRegistry.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import SwiftUI

/// Searchable formula entry with keywords for discovery
struct FormulaEntry: Identifiable {
    let id: String
    let name: String
    let formula: String
    let category: String
    let keywords: [String]
    
    var searchText: String {
        ([name, formula, category] + keywords).joined(separator: " ").lowercased()
    }
    
    func matches(_ query: String) -> Bool {
        let q = query.lowercased().trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return true }
        return searchText.contains(q)
    }
}

enum FormulaRegistry {
    static let all: [FormulaEntry] = [
        FormulaEntry(id: "unit_converter", name: "Unit Converter", formula: "Length, weight, temp, speed, energy", category: "Unit Converter", keywords: ["convert", "length", "weight", "temperature", "speed", "energy", "units"]),
        FormulaEntry(id: "ohms_law", name: "Ohm's Law", formula: "V = I × R", category: "Electrical", keywords: ["voltage", "current", "resistance", "ohm"]),
        FormulaEntry(id: "power", name: "Power", formula: "P = V × I", category: "Electrical", keywords: ["power", "voltage", "current", "watt"]),
        FormulaEntry(id: "resistor", name: "Resistor Calculator", formula: "Series/Parallel", category: "Electrical", keywords: ["resistor", "series", "parallel"]),
        FormulaEntry(id: "capacitance", name: "Capacitance", formula: "Q = CV", category: "Electrical", keywords: ["capacitance", "capacitor", "charge"]),
        FormulaEntry(id: "force", name: "Force", formula: "F = m × a", category: "Physics", keywords: ["force", "mass", "acceleration", "newton"]),
        FormulaEntry(id: "kinetic_energy", name: "Kinetic Energy", formula: "E = ½mv²", category: "Physics", keywords: ["kinetic", "energy", "mass", "velocity"]),
        FormulaEntry(id: "momentum", name: "Momentum", formula: "p = mv", category: "Physics", keywords: ["momentum", "mass", "velocity"]),
        FormulaEntry(id: "velocity", name: "Velocity", formula: "v = d / t", category: "Physics", keywords: ["velocity", "distance", "time", "speed"]),
        FormulaEntry(id: "wavelength", name: "Wavelength", formula: "λ = v / f", category: "Frequency", keywords: ["wavelength", "frequency", "velocity", "wave"]),
        FormulaEntry(id: "rc_filter", name: "RC Filter", formula: "f = 1 / (2πRC)", category: "Frequency", keywords: ["rc", "filter", "frequency", "cutoff"]),
        FormulaEntry(id: "metric_prefix", name: "Metric Prefix", formula: "kilo, mega, giga, milli, micro", category: "Math", keywords: ["metric", "prefix", "kilo", "mega", "giga", "milli", "micro", "nano"])
    ]
    
    static func search(_ query: String) -> [FormulaEntry] {
        let q = query.trimmingCharacters(in: .whitespaces)
        if q.isEmpty { return all }
        return all.filter { $0.matches(q) }
    }
    
    static func entry(for id: String) -> FormulaEntry? {
        all.first { $0.id == id }
    }
    
    static func favorites(_ ids: Set<String>) -> [FormulaEntry] {
        ids.compactMap { entry(for: $0) }
    }
    
    @ViewBuilder
    static func destination(for id: String) -> some View {
        switch id {
        case "unit_converter": UnitConverterView()
        case "ohms_law": OhmsLawView()
        case "power": PowerView()
        case "resistor": ResistorView()
        case "capacitance": CapacitanceView()
        case "force": ForceView()
        case "kinetic_energy": KineticEnergyView()
        case "momentum": MomentumView()
        case "velocity": VelocityView()
        case "wavelength": WavelengthView()
        case "rc_filter": RCFilterView()
        case "metric_prefix": MetricPrefixView()
        default: EmptyView()
        }
    }
}
