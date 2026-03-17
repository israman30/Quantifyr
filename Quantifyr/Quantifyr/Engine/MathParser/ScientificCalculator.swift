//
//  ScientificCalculator.swift
//  Quantifyr
//
//  TI-84 style math engine: Tokenize → RPN → Evaluate.
//  Supports: PEMDAS, parentheses, sin/cos/log/sqrt, variables (x, y), π, e.
//

import Foundation

/// Unified scientific calculator engine using Shunting Yard + RPN evaluation.
enum ScientificCalculator {
    
    /// Evaluates an expression string. Use for calculator mode (no variables).
    /// Example: "3 + 4 * 2" → 11, "sin(π/2)" → 1
    static func evaluate(expression: String) -> Double? {
        let tokens = MathTokenizer.tokenize(expression)
        let rpn = RPNParser.toRPN(tokens)
        return MathEvaluator.evaluate(rpn)
    }
    
    /// Evaluates an expression with variable substitution. Use for graphing (e.g. y = x^2).
    /// - Parameters:
    ///   - expression: Expression string (e.g. "x^2", "sin(x)")
    ///   - x: Value for variable x
    ///   - y: Optional value for variable y
    static func evaluate(expression: String, x: Double, y: Double? = nil) -> Double? {
        var vars: [String: Double] = ["x": x]
        if let y = y { vars["y"] = y }
        
        let tokens = MathTokenizer.tokenize(expression)
        let rpn = RPNParser.toRPN(tokens)
        return MathEvaluator.evaluate(rpn, variables: vars)
    }
}
