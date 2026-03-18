//
//  MathTokenizer.swift
//  Quantifyr
//
//  Breaks input string into tokens: numbers, operators, functions, parentheses, variables.
//

import Foundation

enum MathTokenizer {
    
    private static let supportedFunctions = ["sin", "cos", "tan", "log", "ln", "sqrt", "exp", "abs"]
    
    /// Normalizes input: constants, whitespace, alternate operators.
    static func normalize(_ input: String) -> String {
        var result = input
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "**", with: "^")
            .lowercased()
        
        // Implicit multiplication first (so 2π → 2*π before we replace π)
        result = insertImplicitMultiplication(result)
        
        // Replace π (always safe). e and pi handled in tokenizer to avoid breaking "exp", "sin", "3pi".
        result = result.replacingOccurrences(of: "π", with: String(format: "%.15g", Double.pi))
        
        return result
    }
    
    private static func insertImplicitMultiplication(_ s: String) -> String {
        var result = ""
        var i = s.startIndex
        while i < s.endIndex {
            let c = s[i]
            result.append(c)
            let nextIdx = s.index(after: i)
            guard nextIdx < s.endIndex else { i = nextIdx; continue }
            let next = s[nextIdx]
            let needsStar = (c.isNumber || c == ".") && (next.isLetter || next == "(")
                || (c == "x" || c == "y" || c == ")") && (next == "x" || next == "y" || next.isLetter || next == "(")
            if needsStar {
                result.append("*")
            }
            i = nextIdx
        }
        return result
    }
    
    /// Tokenizes a normalized expression string.
    static func tokenize(_ input: String) -> [ExpressionToken] {
        let normalized = normalize(input)
        var tokens: [ExpressionToken] = []
        var i = normalized.startIndex
        var expectOperand = true  // For unary minus/plus
        
        while i < normalized.endIndex {
            let char = normalized[i]
            
            if char.isNumber || char == "." {
                var numberBuffer = ""
                while i < normalized.endIndex && (normalized[i].isNumber || normalized[i] == ".") {
                    numberBuffer.append(normalized[i])
                    i = normalized.index(after: i)
                }
                if let value = Double(numberBuffer) {
                    tokens.append(.number(value))
                }
                expectOperand = false
                continue
            }
            
            if char.isLetter {
                var ident = ""
                while i < normalized.endIndex && normalized[i].isLetter {
                    ident.append(normalized[i])
                    i = normalized.index(after: i)
                }
                if supportedFunctions.contains(ident) {
                    tokens.append(.function(ident))
                } else if ident == "x" || ident == "y" {
                    tokens.append(.variable(ident))
                } else if ident == "pi" {
                    tokens.append(.number(Double.pi))
                } else if ident == "e" {
                    tokens.append(.number(M_E))
                }
                expectOperand = false
                continue
            }
            
            switch char {
            case "+":
                if expectOperand {
                    // Unary plus — skip
                } else {
                    tokens.append(.operator("+"))
                }
                i = normalized.index(after: i)
            case "-":
                if expectOperand {
                    tokens.append(.number(-1))
                    tokens.append(.operator("*"))
                } else {
                    tokens.append(.operator("-"))
                }
                i = normalized.index(after: i)
            case "*", "/", "^":
                tokens.append(.operator(String(char)))
                expectOperand = true
                i = normalized.index(after: i)
            case "(":
                tokens.append(.leftParen)
                expectOperand = true
                i = normalized.index(after: i)
            case ")":
                tokens.append(.rightParen)
                expectOperand = false
                i = normalized.index(after: i)
            default:
                i = normalized.index(after: i)
            }
        }
        
        return tokens
    }
}
