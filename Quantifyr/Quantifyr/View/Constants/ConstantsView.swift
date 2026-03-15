//
//  ConstantsView.swift
//  Quantifyr
//
//  Browse and search engineering constants database.
//

import SwiftUI

struct ConstantsView: View {
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var searchText = ""
    
    private var searchResults: [EngineeringConstant] {
        EngineeringConstants.search(searchText)
    }
    
    private var groupedByCategory: [(ConstantCategory, [EngineeringConstant])] {
        let results = searchResults
        return ConstantCategory.allCases.compactMap { category in
            let items = results.filter { $0.category == category }
            return items.isEmpty ? nil : (category, items)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Common engineering and scientific constants. Tap to copy.")
                    .font(AppTypography.subtitle)
                    .foregroundStyle(AppTheme.sectionSubtitle)
                    .padding(.bottom, 4)
                
                ForEach(groupedByCategory, id: \.0) { category, constants in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(category.rawValue)
                            .font(AppTypography.sectionTitle)
                            .foregroundStyle(AppTheme.sectionTitle)
                        
                        VStack(spacing: 0) {
                            ForEach(constants) { constant in
                                ConstantRow(constant: constant)
                                if constant.id != constants.last?.id {
                                    Divider()
                                        .padding(.leading, 16)
                                }
                            }
                        }
                        .cardStyle(cornerRadius: 14, hasShadow: true)
                    }
                }
            }
            .padding()
        }
        .searchable(text: $searchText, prompt: "Search constants: pi, c, Planck...")
        .navigationTitle("Constants")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    favoritesManager.toggle("constants")
                } label: {
                    Image(systemName: favoritesManager.isFavorite("constants") ? "star.fill" : "star")
                        .foregroundStyle(favoritesManager.isFavorite("constants") ? .yellow : .secondary)
                }
            }
        }
    }
}

struct ConstantRow: View {
    let constant: EngineeringConstant
    
    var body: some View {
        Button {
            UIPasteboard.general.string = "\(constant.symbol) = \(constant.value) \(constant.unit)"
        } label: {
            HStack(alignment: .top, spacing: 16) {
                Text(constant.symbol)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 44, alignment: .center)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(constant.name)
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(.primary)
                    Text(constant.description)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppTheme.sectionSubtitle)
                    Text("\(constant.value) \(constant.unit)")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(AppTheme.accent)
                }
                
                Spacer()
                
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 16))
                    .foregroundStyle(AppTheme.sectionSubtitle)
            }
            .padding(16)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        ConstantsView()
            .environment(FavoritesManager.shared)
    }
}
