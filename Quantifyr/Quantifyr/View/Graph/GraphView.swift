//
//  GraphView.swift
//  Quantifyr
//
//  Interactive equation grapher using Swift Charts.
//

import SwiftUI
import Charts

struct GraphView: View {
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var equationText = "x**2"
    @State private var xMin: String = "-5"
    @State private var xMax: String = "5"
    @State private var sampleCount: Int = 100
    @State private var errorMessage: String?
    
    private let presetEquations = [
        "x**2",
        "sin(x)",
        "cos(x)",
        "sqrt(x)",
        "2*x+1",
        "x**3-x",
        "exp(-x**2)"
    ]
    
    private var xMinVal: Double { Double(xMin) ?? -5 }
    private var xMaxVal: Double { Double(xMax) ?? 5 }
    
    private var dataPoints: [(x: Double, y: Double)] {
        let lo = min(xMinVal, xMaxVal)
        let hi = max(xMinVal, xMaxVal)
        let step = (hi - lo) / Double(max(sampleCount, 10))
        var points: [(Double, Double)] = []
        var x = lo
        while x <= hi {
            if let y = ExpressionEvaluator.evaluate(equationText, x: x), y.isFinite, abs(y) < 1e10 {
                points.append((x, y))
            }
            x += step
        }
        return points
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Equation input
                VStack(alignment: .leading, spacing: 8) {
                    Text("y =")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppTheme.sectionSubtitle)
                    
                    HStack {
                        TextField("x**2", text: $equationText)
                            .font(.system(.body, design: .monospaced))
                            .textFieldStyle(.roundedBorder)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                        
                        Button("Plot") {
                            errorMessage = nil
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.accent)
                    }
                    
                    if let err = errorMessage {
                        Text(err)
                            .font(AppTypography.caption)
                            .foregroundStyle(.red)
                    }
                }
                .padding()
                .cardStyle(cornerRadius: 14, hasShadow: true)
                
                // Presets
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quick equations")
                        .font(AppTypography.sectionTitle)
                        .foregroundStyle(AppTheme.sectionTitle)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(presetEquations, id: \.self) { eq in
                                Button {
                                    equationText = eq
                                    errorMessage = nil
                                } label: {
                                    Text(eq)
                                        .font(.system(.caption, design: .monospaced))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(AppTheme.accentLight)
                                        .foregroundStyle(AppTheme.accent)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                
                // Range
                VStack(alignment: .leading, spacing: 12) {
                    Text("X range")
                        .font(AppTypography.sectionTitle)
                        .foregroundStyle(AppTheme.sectionTitle)
                    
                    HStack(spacing: 12) {
                        TextField("Min", text: $xMin)
                            .keyboardType(.numbersAndPunctuation)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: .infinity)
                        Text("to")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppTheme.sectionSubtitle)
                        TextField("Max", text: $xMax)
                            .keyboardType(.numbersAndPunctuation)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .cardStyle(cornerRadius: 14, hasShadow: true)
                
                // Chart
                if !dataPoints.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Graph")
                            .font(AppTypography.sectionTitle)
                            .foregroundStyle(AppTheme.sectionTitle)
                        
                        Chart(dataPoints, id: \.x) { pt in
                            LineMark(
                                x: .value("x", pt.x),
                                y: .value("y", pt.y)
                            )
                            .foregroundStyle(AppTheme.accent)
                            .interpolationMethod(.catmullRom)
                        }
                        .chartXAxis {
                            AxisMarks(values: .automatic(desiredCount: 6))
                        }
                        .chartYAxis {
                            AxisMarks(values: .automatic(desiredCount: 6))
                        }
                        .frame(height: 280)
                        .padding()
                        .background(AppTheme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 48))
                            .foregroundStyle(AppTheme.sectionSubtitle)
                        Text("Enter an equation to plot")
                            .font(AppTypography.subtitle)
                            .foregroundStyle(AppTheme.sectionSubtitle)
                        Text("Examples: x**2, sin(x), 2*x+1")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppTheme.sectionSubtitle)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(40)
                }
            }
            .padding()
        }
        .numericKeyboardToolbar()
        .navigationTitle("Graph Equations")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("graph_equations")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("graph_equations") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("graph_equations") ? .yellow : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GraphView()
            .environment(FavoritesManager.shared)
    }
}
