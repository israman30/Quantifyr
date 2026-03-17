//
//  ExpressionEvaluator.swift
//  Quantifyr
//
//  Parses and evaluates mathematical expressions for graphing (e.g., y = x^2, sin(x)).
//  Delegates to ScientificCalculator (TI-84 style parser).
//

import Foundation

enum ExpressionEvaluator {
    /// Evaluates an expression string for a given x value.
    /// Supports: x, +, -, *, /, ^, **, sqrt, abs, sin, cos, tan, log, ln, exp, pi, e
    static func evaluate(_ expression: String, x: Double) -> Double? {
        ScientificCalculator.evaluate(expression: expression, x: x)
    }
}
