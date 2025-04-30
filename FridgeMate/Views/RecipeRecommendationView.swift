//
//  RecipeRecommendationView.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import SwiftUI
import Foundation

struct RecipeRecommendationView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @State private var selectedTier: RecipeTier?
    
    var body: some View {
        VStack {
            // Tier Selection
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach([RecipeTier.tier1, .tier2, .tier3], id: \.self) { tier in
                        Button(action: {
                            selectedTier = selectedTier == tier ? nil : tier
                        }) {
                            VStack {
                                Image(systemName: tierIcon(for: tier))
                                    .font(.title)
                                Text(tierTitle(for: tier))
                                    .font(.caption)
                            }
                            .padding()
                            .background(selectedTier == tier ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedTier == tier ? .white : .primary)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            
            // Recipe List
            List {
                ForEach(viewModel.recommendedRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        RecipeCard(recipe: recipe)
                    }
                }
            }
        }
        .navigationTitle("Recipe Recommendations")
        .onAppear {
            viewModel.findRecipes()
        }
    }
    
    private func tierIcon(for tier: RecipeTier) -> String {
        switch tier {
        case .tier1: return "star.fill"
        case .tier2: return "star.leadinghalf.filled"
        case .tier3: return "star"
        }
    }
    
    private func tierTitle(for tier: RecipeTier) -> String {
        switch tier {
        case .tier1: return "All Ingredients"
        case .tier2: return "Most Ingredients"
        case .tier3: return "Missing 1-2"
        }
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.name)
                .font(.headline)
            
            Text(recipe.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            HStack {
                Label("\(recipe.cookingTime) min", systemImage: "clock")
                Spacer()
                Label(recipe.difficulty.rawValue, systemImage: "chart.bar")
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(recipe.name)
                    .font(.title)
                    .bold()
                
                Text(recipe.description)
                    .font(.body)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ingredients")
                        .font(.headline)
                    
                    ForEach(recipe.ingredients) { ingredient in
                        HStack {
                            Text("• \(ingredient.name)")
                            Spacer()
                            Text("\(String(format: "%.1f", ingredient.amount)) \(ingredient.unit.rawValue)")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Instructions")
                        .font(.headline)
                    
                    ForEach(recipe.instructions.indices, id: \.self) { index in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .fontWeight(.bold)
                            Text(recipe.instructions[index])
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Recipe Details")
    }
}

