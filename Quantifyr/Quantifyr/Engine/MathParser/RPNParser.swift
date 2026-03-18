//
//  RPNParser.swift
//  Quantifyr
//
//  Shunting Yard algorithm — converts tokens to Reverse Polish Notation.
//

import Foundation

enum RPNParser {
    
    /// Operator precedence (higher = evaluated first).
    static func precedence(_ op: String) -> Int {
        switch op {
        case "+", "-": return 1
        case "*", "/": return 2
        case "^": return 3
        default: return 0
        }
    }
    
    /// Right-associative operators (e.g. ^).
    static func isRightAssociative(_ op: String) -> Bool {
        op == "^"
    }
    
    /// Converts infix tokens to RPN (postfix).
    static func toRPN(_ tokens: [ExpressionToken]) -> [ExpressionToken] {
        var output: [ExpressionToken] = []
        var stack: [ExpressionToken] = []
        
        for token in tokens {
            switch token {
            case .number, .variable:
                output.append(token)
                
            case .function:
                stack.append(token)
                
            case .operator(let op1):
                while let top = stack.last {
                    if case .operator(let op2) = top {
                        let useTop = isRightAssociative(op1)
                            ? precedence(op2) > precedence(op1)
                            : precedence(op2) >= precedence(op1)
                        if useTop {
                            output.append(stack.removeLast())
                        } else {
                            break
                        }
                    } else {
                        break
                    }
                }
                stack.append(token)
                
            case .leftParen:
                stack.append(token)
                
            case .rightParen:
                while let top = stack.last {
                    if case .leftParen = top {
                        stack.removeLast()
                        break
                    }
                    output.append(stack.removeLast())
                }
                // Pop the function that was pushed before the leftParen (e.g. sin(...))
                if case .function = stack.last {
                    output.append(stack.removeLast())
                }
            }
        }
        
        while let token = stack.popLast() {
            if case .leftParen = token { continue }
            output.append(token)
        }
        
        return output
    }
}
