//
//  ExpressionEvaluator.swift
//  Quantifyr
//
//  Parses and evaluates mathematical expressions for graphing (e.g., y = x^2, sin(x)).
//

import Foundation

enum ExpressionEvaluator {
    /// Evaluates an expression string for a given x value.
    /// Supports: x, +, -, *, /, ^, **, sqrt, abs, sin, cos, tan, log, exp, pi, e
    static func evaluate(_ expression: String, x: Double) -> Double? {
        let normalized = normalize(expression)
        let substituted = substituted(normalized, x: x)
        return evaluateExpression(substituted)
    }
    
    private static func normalize(_ s: String) -> String {
        var result = s
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .lowercased()
        
        result = result.replacingOccurrences(of: "^", with: "**")
        
        var i = result.startIndex
        while i < result.endIndex {
            let c = result[i]
            if c == "x" {
                let nextIdx = result.index(after: i)
                if nextIdx < result.endIndex {
                    let next = result[nextIdx]
                    if next == "x" || next == "(" || next.isNumber {
                        result.insert("*", at: nextIdx)
                    }
                }
            } else if c.isNumber || c == "." {
                let nextIdx = result.index(after: i)
                if nextIdx < result.endIndex && result[nextIdx] == "x" {
                    result.insert("*", at: nextIdx)
                }
            } else if c == ")" {
                let nextIdx = result.index(after: i)
                if nextIdx < result.endIndex {
                    let next = result[nextIdx]
                    if next == "x" || next == "(" || next.isNumber {
                        result.insert("*", at: nextIdx)
                    }
                }
            }
            i = result.index(after: i)
        }
        return result
    }
    
    private static func substituted(_ s: String, x: Double) -> String {
        let xStr = formatNumber(x)
        var result = ""
        var i = s.startIndex
        
        while i < s.endIndex {
            if s[i] == "x" {
                let prevIdx = i > s.startIndex ? s.index(before: i) : i
                let nextIdx = s.index(after: i)
                let prevIsLetter = prevIdx < i && s[prevIdx].isLetter
                let nextIsLetter = nextIdx < s.endIndex && s[nextIdx].isLetter
                if !prevIsLetter && !nextIsLetter {
                    result += "(\(xStr))"
                } else {
                    result += String(s[i])
                }
            } else {
                result += String(s[i])
            }
            i = s.index(after: i)
        }
        
        return result
    }
    
    private static func formatNumber(_ n: Double) -> String {
        if n == .infinity || n == -.infinity || n.isNaN { return "0" }
        if abs(n) < 1e-10 && n != 0 { return "0" }
        return String(format: "%.15g", n)
    }
    
    private static func evaluateExpression(_ expr: String) -> Double? {
        var expr = expr.trimmingCharacters(in: .whitespaces)
        guard !expr.isEmpty else { return nil }
        
        expr = evaluateAllFunctionCalls(expr)
        expr = expr
            .replacingOccurrences(of: "\\bpi\\b", with: String(format: "%.15g", Double.pi), options: .regularExpression)
            .replacingOccurrences(of: "\\be\\b", with: String(format: "%.15g", M_E), options: .regularExpression)
        let nsExpr = expr.replacingOccurrences(of: "**", with: "^")
        
        let expression = NSExpression(format: nsExpr)
        guard let result = expression.expressionValue(with: nil, context: nil) as? NSNumber else {
            return nil
        }
        
        let value = result.doubleValue
        guard value.isFinite else { return nil }
        return value
    }
    
    private static func evaluateAllFunctionCalls(_ expr: String) -> String {
        var result = expr
        let functions = ["sin", "cos", "tan", "sqrt", "log", "exp", "abs"]
        
        for fn in functions {
            var searchStart = result.startIndex
            while let range = result.range(of: fn, range: searchStart..<result.endIndex) {
                let afterFn = range.upperBound
                guard afterFn < result.endIndex else { break }
                let parenStart = result[afterFn...].firstIndex(where: { $0 != " " && $0 != "\t" }) ?? afterFn
                guard parenStart < result.endIndex, result[parenStart] == "(" else {
                    searchStart = range.upperBound
                    continue
                }
                guard let (inner, endIdx) = extractMatchingParens(result, from: parenStart) else {
                    searchStart = range.upperBound
                    continue
                }
                guard let v = evaluateExpression(String(inner)) else {
                    searchStart = range.upperBound
                    continue
                }
                let applied = formatNumber(applyFunction(fn, v))
                let fullRange = range.lowerBound..<result.index(after: endIdx)
                result.replaceSubrange(fullRange, with: applied)
                searchStart = result.startIndex
            }
        }
        return result
    }
    
    private static func extractMatchingParens(_ s: String, from start: String.Index) -> (Substring, String.Index)? {
        guard start < s.endIndex, s[start] == "(" else { return nil }
        var depth = 1
        var i = s.index(after: start)
        while i < s.endIndex && depth > 0 {
            if s[i] == "(" { depth += 1 }
            else if s[i] == ")" { depth -= 1 }
            i = s.index(after: i)
        }
        guard depth == 0 else { return nil }
        let innerStart = s.index(after: start)
        let innerEnd = s.index(before: i)
        return (s[innerStart..<innerEnd], s.index(before: i))
    }
    
    private static func applyFunction(_ name: String, _ x: Double) -> Double {
        switch name {
        case "sin": return sin(x)
        case "cos": return cos(x)
        case "tan": return tan(x)
        case "sqrt": return x >= 0 ? sqrt(x) : .nan
        case "log": return x > 0 ? log10(x) : .nan
        case "exp": return exp(x)
        case "abs": return abs(x)
        default: return x
        }
    }
}

