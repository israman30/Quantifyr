//
//  ValidatedDecimalInput.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/14/26.
//

import SwiftUI

/// Filters text input to allow only valid decimal numbers: digits, one decimal point, optional minus at start.
/// Prevents invalid characters (letters, multiple decimals, etc.) from being entered.
func filterDecimalInput(_ text: String) -> String {
    var result = ""
    var hasDecimal = false
    var hasMinus = false
    for char in text {
        if char == "-" && result.isEmpty && !hasMinus {
            hasMinus = true
            result.append(char)
        } else if char == "." && !hasDecimal {
            hasDecimal = true
            result.append(char)
        } else if char.isNumber {
            result.append(char)
        }
    }
    return result
}

struct DecimalInputModifier: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text) { _, newValue in
                let filtered = filterDecimalInput(newValue)
                if filtered != newValue {
                    text = filtered
                }
            }
    }
}

extension View {
    /// Applies validation to restrict TextField input to valid decimal numbers only.
    /// Use with numeric formula inputs to prevent invalid characters.
    func validatedDecimalInput(_ binding: Binding<String>) -> some View {
        modifier(DecimalInputModifier(text: binding))
    }
    
    /// Adds a Done toolbar above the numeric keyboard for easy dismissal.
    /// Use with TextFields that have .keyboardType(.decimalPad).
    func numericKeyboardToolbar() -> some View {
        modifier(NumericKeyboardToolbarModifier())
    }
}

/// Adds Done button above decimal pad keyboard for better UX.
struct NumericKeyboardToolbarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
    }
}
