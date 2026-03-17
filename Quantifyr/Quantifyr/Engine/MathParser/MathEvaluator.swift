//
//  MathEvaluator.swift
//  Quantifyr
//
//  Evaluates RPN (postfix) token stream to a numeric result.
//

import Foundation

enum MathEvaluator {
    
    /// Evaluates RPN tokens. Supports variables via the `variables` dictionary (e.g. ["x": 2.0]).
    static func evaluate(_ tokens: [ExpressionToken], variables: [String: Double] = [:]) -> Double? {
        var stack: [Double] = []
        
        for token in tokens {
            switch token {
            case .number(let value):
                stack.append(value)
                
            case .variable(let name):
                if let value = variables[name] {
                    stack.append(value)
                } else {
                    return nil
                }
                
            case .operator(let op):
                guard let b = stack.popLast(),
                      let a = stack.popLast()
                else { return nil }
                
                switch op {
                case "+": stack.append(a + b)
                case "-": stack.append(a - b)
                case "*": stack.append(a * b)
                case "/": stack.append(b != 0 ? a / b : .nan)
                case "^": stack.append(pow(a, b))
                default: return nil
                }
                
            case .function(let fn):
                guard let value = stack.popLast() else { return nil }
                
                switch fn {
                case "sin": stack.append(sin(value))
                case "cos": stack.append(cos(value))
                case "tan": stack.append(tan(value))
                case "log": stack.append(value > 0 ? log10(value) : .nan)
                case "ln": stack.append(log(value))
                case "sqrt": stack.append(value >= 0 ? sqrt(value) : .nan)
                case "exp": stack.append(exp(value))
                case "abs": stack.append(abs(value))
                default: return nil
                }
                
            case .leftParen, .rightParen:
                break
            }
        }
        
        guard stack.count == 1, let result = stack.first else { return nil }
        guard result.isFinite else { return nil }
        return result
    }
}
