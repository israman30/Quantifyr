//
//  EngineeringConstants.swift
//  Quantifyr
//
//  Database of common engineering and scientific constants.
//

import Foundation

struct EngineeringConstant: Identifiable {
    let id: String
    let symbol: String
    let name: String
    let value: String
    let unit: String
    let description: String
    let category: ConstantCategory
    let keywords: [String]
    
    var searchText: String {
        ([symbol, name, description, unit] + keywords).joined(separator: " ").lowercased()
    }
    
    func matches(_ query: String) -> Bool {
        let q = query.lowercased().trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return true }
        return searchText.contains(q)
    }
}

enum ConstantCategory: String, CaseIterable {
    case mathematics = "Mathematics"
    case physics = "Physics"
    case electrical = "Electrical"
    case chemistry = "Chemistry"
    case astronomy = "Astronomy"
}

enum EngineeringConstants {
    static let all: [EngineeringConstant] = [
        // Mathematics
        EngineeringConstant(id: "pi", symbol: "π", name: "Pi", value: "3.14159265358979", unit: "—", description: "Ratio of circle circumference to diameter", category: .mathematics, keywords: ["circle", "trigonometry", "geometry"]),
        EngineeringConstant(id: "e", symbol: "e", name: "Euler's number", value: "2.71828182845905", unit: "—", description: "Base of natural logarithm", category: .mathematics, keywords: ["exponential", "log", "growth"]),
        EngineeringConstant(id: "phi", symbol: "φ", name: "Golden ratio", value: "1.61803398874989", unit: "—", description: "Golden ratio (1+√5)/2", category: .mathematics, keywords: ["golden", "fibonacci"]),
        
        // Physics
        EngineeringConstant(id: "c", symbol: "c", name: "Speed of light", value: "299792458", unit: "m/s", description: "Speed of light in vacuum", category: .physics, keywords: ["light", "relativity", "vacuum"]),
        EngineeringConstant(id: "G", symbol: "G", name: "Gravitational constant", value: "6.67430e-11", unit: "m³/(kg·s²)", description: "Newton's gravitational constant", category: .physics, keywords: ["gravity", "newton"]),
        EngineeringConstant(id: "h", symbol: "h", name: "Planck constant", value: "6.62607015e-34", unit: "J·s", description: "Quantum of action", category: .physics, keywords: ["quantum", "photon", "energy"]),
        EngineeringConstant(id: "hbar", symbol: "ℏ", name: "Reduced Planck constant", value: "1.054571817e-34", unit: "J·s", description: "h / (2π)", category: .physics, keywords: ["quantum", "reduced"]),
        EngineeringConstant(id: "g", symbol: "g", name: "Standard gravity", value: "9.80665", unit: "m/s²", description: "Standard acceleration due to gravity", category: .physics, keywords: ["gravity", "acceleration", "earth"]),
        EngineeringConstant(id: "Na", symbol: "Nₐ", name: "Avogadro constant", value: "6.02214076e23", unit: "mol⁻¹", description: "Particles per mole", category: .physics, keywords: ["mole", "avogadro", "particles"]),
        EngineeringConstant(id: "k_B", symbol: "k_B", name: "Boltzmann constant", value: "1.380649e-23", unit: "J/K", description: "Relates energy to temperature", category: .physics, keywords: ["temperature", "thermodynamics", "entropy"]),
        EngineeringConstant(id: "sigma", symbol: "σ", name: "Stefan-Boltzmann constant", value: "5.670374419e-8", unit: "W/(m²·K⁴)", description: "Black-body radiation", category: .physics, keywords: ["radiation", "stefan", "blackbody"]),
        
        // Electrical
        EngineeringConstant(id: "e0", symbol: "ε₀", name: "Vacuum permittivity", value: "8.8541878128e-12", unit: "F/m", description: "Electric constant, permittivity of free space", category: .electrical, keywords: ["capacitance", "electric", "vacuum"]),
        EngineeringConstant(id: "mu0", symbol: "μ₀", name: "Vacuum permeability", value: "1.25663706212e-6", unit: "H/m", description: "Magnetic constant, permeability of free space", category: .electrical, keywords: ["magnetic", "inductance", "vacuum"]),
        EngineeringConstant(id: "e_charge", symbol: "e", name: "Elementary charge", value: "1.602176634e-19", unit: "C", description: "Charge of electron", category: .electrical, keywords: ["electron", "charge", "coulomb"]),
        
        // Chemistry
        EngineeringConstant(id: "R", symbol: "R", name: "Gas constant", value: "8.314462618", unit: "J/(mol·K)", description: "Ideal gas law constant", category: .chemistry, keywords: ["gas", "ideal", "pv=nrt"]),
        EngineeringConstant(id: "F", symbol: "F", name: "Faraday constant", value: "96485.33212", unit: "C/mol", description: "Charge per mole of electrons", category: .chemistry, keywords: ["electrochemistry", "faraday"]),
        
        // Astronomy
        EngineeringConstant(id: "au", symbol: "au", name: "Astronomical unit", value: "1.495978707e11", unit: "m", description: "Earth-Sun distance", category: .astronomy, keywords: ["astronomy", "sun", "distance"]),
        EngineeringConstant(id: "ly", symbol: "ly", name: "Light year", value: "9.4607304725808e15", unit: "m", description: "Distance light travels in one year", category: .astronomy, keywords: ["light", "year", "distance"]),
        EngineeringConstant(id: "parsec", symbol: "pc", name: "Parsec", value: "3.08567758149137e16", unit: "m", description: "Parallax of one arcsecond", category: .astronomy, keywords: ["parallax", "astronomy"]),
    ]
    
    static func search(_ query: String) -> [EngineeringConstant] {
        let q = query.trimmingCharacters(in: .whitespaces)
        if q.isEmpty { return all }
        return all.filter { $0.matches(q) }
    }
    
    static func byCategory(_ category: ConstantCategory) -> [EngineeringConstant] {
        all.filter { $0.category == category }
    }
    
    static func entry(for id: String) -> EngineeringConstant? {
        all.first { $0.id == id }
    }
}
