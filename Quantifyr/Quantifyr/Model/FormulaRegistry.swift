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
        // Electrical Engineering
        FormulaEntry(id: "ohms_law", name: "Ohm's Law", formula: "V = I × R", category: "Electrical", keywords: ["voltage", "current", "resistance", "ohm"]),
        FormulaEntry(id: "ohms_law", name: "Current", formula: "I = V / R", category: "Electrical", keywords: ["current", "voltage", "resistance", "ampere"]),
        FormulaEntry(id: "ohms_law", name: "Resistance", formula: "R = V / I", category: "Electrical", keywords: ["resistance", "voltage", "current", "ohm"]),
        FormulaEntry(id: "power", name: "Electrical Power", formula: "P = V × I", category: "Electrical", keywords: ["power", "voltage", "current", "watt"]),
        FormulaEntry(id: "power", name: "Power (Current form)", formula: "P = I²R", category: "Electrical", keywords: ["power", "current", "resistance"]),
        FormulaEntry(id: "power", name: "Power (Voltage form)", formula: "P = V² / R", category: "Electrical", keywords: ["power", "voltage", "resistance"]),
        FormulaEntry(id: "power", name: "Energy", formula: "E = P × t", category: "Electrical", keywords: ["energy", "power", "time", "joule"]),
        FormulaEntry(id: "resistor", name: "Series Resistance", formula: "R_total = R₁ + R₂ + ...", category: "Electrical", keywords: ["resistor", "series"]),
        FormulaEntry(id: "resistor", name: "Parallel Resistance", formula: "1/R = 1/R₁ + 1/R₂", category: "Electrical", keywords: ["resistor", "parallel"]),
        FormulaEntry(id: "capacitance", name: "Capacitor Energy", formula: "E = ½ C V²", category: "Electrical", keywords: ["capacitor", "energy", "capacitance", "voltage"]),
        FormulaEntry(id: "capacitance", name: "Capacitor Charge", formula: "Q = C × V", category: "Electrical", keywords: ["capacitance", "capacitor", "charge", "coulomb"]),
        FormulaEntry(id: "rc_filter", name: "RC Time Constant", formula: "τ = R × C", category: "Electrical", keywords: ["rc", "time constant", "tau", "capacitor", "resistor"]),
        // Physics
        FormulaEntry(id: "force", name: "Force", formula: "F = m × a", category: "Physics", keywords: ["force", "mass", "acceleration", "newton"]),
        FormulaEntry(id: "momentum", name: "Momentum", formula: "p = m × v", category: "Physics", keywords: ["momentum", "mass", "velocity"]),
        FormulaEntry(id: "kinetic_energy", name: "Kinetic Energy", formula: "KE = ½mv²", category: "Physics", keywords: ["kinetic", "energy", "mass", "velocity"]),
        FormulaEntry(id: "potential_energy", name: "Potential Energy", formula: "PE = mgh", category: "Physics", keywords: ["potential", "energy", "mass", "gravity", "height"]),
        FormulaEntry(id: "velocity", name: "Velocity", formula: "v = d / t", category: "Physics", keywords: ["velocity", "distance", "time", "speed"]),
        FormulaEntry(id: "acceleration", name: "Acceleration", formula: "a = Δv / t", category: "Physics", keywords: ["acceleration", "velocity", "time", "delta"]),
        FormulaEntry(id: "density", name: "Density", formula: "ρ = m / V", category: "Physics", keywords: ["density", "mass", "volume", "rho"]),
        FormulaEntry(id: "pressure", name: "Pressure", formula: "P = F / A", category: "Physics", keywords: ["pressure", "force", "area", "pascal"]),
        FormulaEntry(id: "work", name: "Work", formula: "W = F × d", category: "Physics", keywords: ["work", "force", "distance", "joule"]),
        FormulaEntry(id: "physics_power", name: "Power", formula: "P = W / t", category: "Physics", keywords: ["power", "work", "time", "watt"]),
        FormulaEntry(id: "centripetal_force", name: "Centripetal Force", formula: "F = mv² / r", category: "Physics", keywords: ["centripetal", "force", "circular", "radius"]),
        FormulaEntry(id: "gravitational_force", name: "Gravitational Force", formula: "F = G(m₁m₂)/r²", category: "Physics", keywords: ["gravity", "gravitational", "force", "newton", "mass"]),
        // Wave & Frequency
        FormulaEntry(id: "wave_speed", name: "Wave Speed", formula: "v = fλ", category: "Frequency", keywords: ["wave", "speed", "frequency", "wavelength", "velocity"]),
        FormulaEntry(id: "frequency_period", name: "Frequency", formula: "f = 1 / T", category: "Frequency", keywords: ["frequency", "period", "hertz"]),
        FormulaEntry(id: "frequency_period", name: "Period", formula: "T = 1 / f", category: "Frequency", keywords: ["period", "frequency", "time"]),
        FormulaEntry(id: "angular_frequency", name: "Angular Frequency", formula: "ω = 2πf", category: "Frequency", keywords: ["angular", "frequency", "omega", "radians"]),
        FormulaEntry(id: "wavelength", name: "Wavelength", formula: "λ = v / f", category: "Frequency", keywords: ["wavelength", "frequency", "velocity", "wave"]),
        FormulaEntry(id: "rc_filter", name: "RC Filter Frequency", formula: "f = 1 / (2πRC)", category: "Frequency", keywords: ["rc", "filter", "frequency", "cutoff"]),
        FormulaEntry(id: "inductive_reactance", name: "Inductive Reactance", formula: "Xₗ = 2πfL", category: "Frequency", keywords: ["inductive", "reactance", "inductor", "impedance"]),
        FormulaEntry(id: "capacitive_reactance", name: "Capacitive Reactance", formula: "Xc = 1 / (2πfC)", category: "Frequency", keywords: ["capacitive", "reactance", "capacitor", "impedance"]),
        // Mathematics
        FormulaEntry(id: "slope", name: "Slope", formula: "m = (y₂ - y₁)/(x₂ - x₁)", category: "Math", keywords: ["slope", "line", "coordinates", "gradient"]),
        FormulaEntry(id: "quadratic_formula", name: "Quadratic Formula", formula: "x = (-b ± √(b²-4ac)) / 2a", category: "Math", keywords: ["quadratic", "equation", "roots", "discriminant"]),
        FormulaEntry(id: "area_circle", name: "Area Circle", formula: "A = πr²", category: "Math", keywords: ["area", "circle", "radius", "pi"]),
        FormulaEntry(id: "circumference", name: "Circumference", formula: "C = 2πr", category: "Math", keywords: ["circumference", "circle", "perimeter", "radius"]),
        FormulaEntry(id: "area_triangle", name: "Area Triangle", formula: "A = ½bh", category: "Math", keywords: ["area", "triangle", "base", "height"]),
        FormulaEntry(id: "pythagorean", name: "Pythagorean", formula: "a² + b² = c²", category: "Math", keywords: ["pythagorean", "theorem", "right triangle", "hypotenuse"]),
        FormulaEntry(id: "volume_sphere", name: "Volume Sphere", formula: "V = 4/3 πr³", category: "Math", keywords: ["volume", "sphere", "radius"]),
        FormulaEntry(id: "volume_cylinder", name: "Volume Cylinder", formula: "V = πr²h", category: "Math", keywords: ["volume", "cylinder", "radius", "height"]),
        FormulaEntry(id: "average", name: "Average", formula: "mean = Σx / n", category: "Math", keywords: ["average", "mean", "statistics"]),
        FormulaEntry(id: "metric_prefix", name: "Metric Prefix", formula: "kilo, mega, giga, milli, micro", category: "Math", keywords: ["metric", "prefix", "kilo", "mega", "giga", "milli", "micro", "nano"]),
        FormulaEntry(id: "graph_equations", name: "Graph Equations", formula: "y = f(x)", category: "Math", keywords: ["graph", "plot", "equation", "chart", "xy", "sin", "cos"]),
        FormulaEntry(id: "constants", name: "Engineering Constants", formula: "π, c, G, h, ε₀, ...", category: "Reference", keywords: ["constants", "pi", "planck", "speed of light", "gravity", "avogadro"])
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
        case "potential_energy": PotentialEnergyView()
        case "velocity": VelocityView()
        case "acceleration": AccelerationView()
        case "density": DensityView()
        case "pressure": PressureView()
        case "work": WorkView()
        case "physics_power": PhysicsPowerView()
        case "centripetal_force": CentripetalForceView()
        case "gravitational_force": GravitationalForceView()
        case "wave_speed": WaveSpeedView()
        case "frequency_period": FrequencyPeriodView()
        case "angular_frequency": AngularFrequencyView()
        case "wavelength": WavelengthView()
        case "rc_filter": RCFilterView()
        case "inductive_reactance": InductiveReactanceView()
        case "capacitive_reactance": CapacitiveReactanceView()
        case "slope": SlopeView()
        case "quadratic_formula": QuadraticFormulaView()
        case "area_circle": AreaCircleView()
        case "circumference": CircumferenceView()
        case "area_triangle": AreaTriangleView()
        case "pythagorean": PythagoreanView()
        case "volume_sphere": VolumeSphereView()
        case "volume_cylinder": VolumeCylinderView()
        case "average": AverageView()
        case "metric_prefix": MetricPrefixView()
        case "graph_equations": GraphView()
        case "constants": ConstantsView()
        default: EmptyView()
        }
    }
}
