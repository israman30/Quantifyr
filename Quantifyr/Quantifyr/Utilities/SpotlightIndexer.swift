//
//  SpotlightIndexer.swift
//  Quantifyr
//
//  Indexes formulas for iOS Spotlight search. Users can search "Ohm's Law" in Spotlight
//  and open Quantifyr directly to that formula.
//

import CoreSpotlight
import UIKit

enum SpotlightIndexer {
    private static let domainIdentifier = "com.israman.somenews.Quantifyr.formulas"
    
    /// Index all formulas for Spotlight search. Call on app launch.
    static func indexFormulas() {
        let items = FormulaRegistry.all.map { entry in
            CSSearchableItem(
                uniqueIdentifier: "formula:\(entry.id)",
                domainIdentifier: domainIdentifier,
                attributeSet: attributeSet(for: entry)
            )
        }
        
        CSSearchableIndex.default().indexSearchableItems(items) { error in
            if let error {
                #if DEBUG
                print("Spotlight indexing error: \(error.localizedDescription)")
                #endif
            }
        }
    }
    
    /// Index engineering constants for Spotlight.
    static func indexConstants() {
        let items = EngineeringConstants.all.map { constant in
            CSSearchableItem(
                uniqueIdentifier: "constant:\(constant.id)",
                domainIdentifier: domainIdentifier,
                attributeSet: attributeSet(for: constant)
            )
        }
        
        CSSearchableIndex.default().indexSearchableItems(items) { error in
            if let error {
                #if DEBUG
                print("Spotlight constants indexing error: \(error.localizedDescription)")
                #endif
            }
        }
    }
    
    /// Index graph equations feature.
    static func indexGraph() {
        let entry = FormulaEntry(
            id: "graph_equations",
            name: "Graph Equations",
            formula: "y = f(x)",
            category: "Math",
            keywords: ["graph", "plot", "equation", "chart", "xy"]
        )
        let item = CSSearchableItem(
            uniqueIdentifier: "formula:graph_equations",
            domainIdentifier: domainIdentifier,
            attributeSet: attributeSet(for: entry)
        )
        CSSearchableIndex.default().indexSearchableItems([item]) { _ in }
    }
    
    /// Index constants feature.
    static func indexConstantsFeature() {
        let entry = FormulaEntry(
            id: "constants",
            name: "Engineering Constants",
            formula: "π, c, G, h, ε₀, ...",
            category: "Reference",
            keywords: ["constants", "pi", "planck", "speed of light", "gravity"]
        )
        let item = CSSearchableItem(
            uniqueIdentifier: "formula:constants",
            domainIdentifier: domainIdentifier,
            attributeSet: attributeSet(for: entry)
        )
        CSSearchableIndex.default().indexSearchableItems([item]) { _ in }
    }
    
    /// Index all app content for Spotlight.
    static func indexAll() {
        indexFormulas()
        indexConstants()
        indexGraph()
        indexConstantsFeature()
    }
    
    private static func attributeSet(for entry: FormulaEntry) -> CSSearchableItemAttributeSet {
        let set = CSSearchableItemAttributeSet(contentType: .content)
        set.title = entry.name
        set.contentDescription = "\(entry.formula) — \(entry.category)"
        set.keywords = entry.keywords + [entry.category, "formula", "calculator", "Quantifyr"]
        return set
    }
    
    private static func attributeSet(for constant: EngineeringConstant) -> CSSearchableItemAttributeSet {
        let set = CSSearchableItemAttributeSet(contentType: .content)
        set.title = "\(constant.symbol) — \(constant.name)"
        set.contentDescription = "\(constant.value) \(constant.unit)"
        set.keywords = constant.keywords + [constant.symbol, constant.name, "constant", "Quantifyr"]
        return set
    }
    
    /// Parse Spotlight result to get formula/constant ID for deep linking.
    static func parseIdentifier(_ uniqueId: String) -> (type: String, id: String)? {
        if uniqueId.hasPrefix("formula:") {
            return ("formula", String(uniqueId.dropFirst("formula:".count)))
        }
        if uniqueId.hasPrefix("constant:") {
            return ("constant", String(uniqueId.dropFirst("constant:".count)))
        }
        return nil
    }
}
