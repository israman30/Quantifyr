//
//  FormulaEngine.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import Foundation

class FormulaEngine {
    
    static let shared = FormulaEngine()
    
    private init() {}
    
    func compute(formula: Formula, inputs: [Double]) -> Double {
        return formula.compute(inputs)
    }
    
}
