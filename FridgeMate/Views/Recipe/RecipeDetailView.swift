//
//  RecipeDetailView.swift
//  FridgeMate
//
//  Created by Hai Tong on 4/5/25.
//

import SwiftUI

/// Detailed recipe view that fetches and displays full recipe info without rendering HTML tags.
struct RecipeDetailView: View {
    let recipeID: Int
    @StateObject private var detailVM = RecipeDetailModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Image
                if let urlString = detailVM.detail?.image,
                   let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color(.systemGray5)
                    }
                    .frame(height: 250)
                    .clipped()
                }

                // Title
                Text(detailVM.detail?.title ?? "Loading…")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 16) {
                    // Summary (strip HTML tags)
                    if let rawSummary = detailVM.detail?.summary {
                        let summaryText = rawSummary
                            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                        Text(summaryText)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Divider()

                    // Ingredients
                    if let ingredients = detailVM.detail?.extendedIngredients {
                        Text("Ingredients")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 4)

                        ForEach(ingredients) { ing in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                Text(ing.original)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }

                    Divider()

                    // Instructions (strip HTML tags)
                    if let rawInstr = detailVM.detail?.instructions {
                        let instrText = rawInstr
                            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                        Text("Instructions")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 4)

                        Text(instrText)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Divider()

                    // Nutrition Grid
                    if let nutrients = detailVM.detail?.nutrition?.nutrients {
                        Text("Nutrition")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 4)

                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 120), spacing: 16)],
                            spacing: 12
                        ) {
                            ForEach(nutrients) { nut in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(nut.name)
                                        .font(.subheadline)
                                        .bold()
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text(String(format: "%.0f%@", nut.amount, nut.unit))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            detailVM.fetchDetail(for: recipeID)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeDetailView(recipeID: 716429)
        }
    }
}
