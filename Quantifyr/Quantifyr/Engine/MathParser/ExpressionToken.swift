//
//  ExpressionToken.swift
//  Quantifyr
//
//  TI-84 style math parser — token representation.
//

import Foundation

/// Token types produced by the tokenizer.
enum ExpressionToken: Equatable {
    case number(Double)
    case `operator`(String)
    case function(String)
    case leftParen
    case rightParen
    case variable(String)
}
