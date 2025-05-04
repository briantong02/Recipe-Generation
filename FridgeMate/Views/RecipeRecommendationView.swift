//
//  RecipeRecommendationView.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import SwiftUI

struct RecipeRecommendationView: View {
    @ObservedObject var fridgeVM: FridgeViewModel
    @StateObject private var recipeVM = RecipeRecommendationViewModel()
    @State private var showDetail = false

    var body: some View {
        Group {
            if recipeVM.isLoadingRecipes {
                ProgressView("Searching recipes…")
            } else if let err = recipeVM.errorMessage {
                Text("Error: \(err)")
                    .foregroundColor(.red)
            } else {
                List(recipeVM.recommendedRecipes) { recipe in
                    Button(action: {
                        recipeVM.fetchDetail(for: recipe.id)
                        showDetail = true
                    }) {
                        RecipeRow(recipe: recipe)
                    }
                }
            }
        }
        .navigationTitle("Recommendations")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Refresh") {
                    recipeVM.findRecipes(from: fridgeVM.ingredients)
                }
            }
        }
        .onAppear {
            recipeVM.findRecipes(from: fridgeVM.ingredients)
        }
        .sheet(isPresented: $showDetail) {
            if let detail = recipeVM.selectedRecipeDetail {
                RecipeDetailSheet(detail: detail)
            }
        }
    }
}

// MARK: - Supporting Views

struct RecipeRow: View {
    let recipe: APIRecipe
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: recipe.image)) { img in
                img.resizable().scaledToFill()
            } placeholder: {
                Rectangle().opacity(0.3)
            }
            .frame(width: 60, height: 60)
            .cornerRadius(6)

            Text(recipe.title)
                .font(.headline)
                .lineLimit(2)
        }
    }
}

// Sheet view for detailed recipe
struct RecipeDetailSheet: View {
    let detail: APIDetailedRecipe
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: detail.image)) { img in
                    img.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                Text(detail.title)
                    .font(.title).bold()
                Text(detail.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))

                Text("Ingredients").font(.headline)
                ForEach(detail.extendedIngredients) { ing in
                    Text("• \(ing.original)")
                }

                if let block = detail.analyzedInstructions.first {
                    Text("Instructions").font(.headline)
                    ForEach(block.steps) { step in
                        Text("\(step.number). \(step.step)")
                    }
                }

                Text("Nutrition").font(.headline)
                ForEach(detail.nutrition.nutrients) { nut in
                    Text("• \(nut.name): \(nut.amount, specifier: "%.1f")\(nut.unit) (\(nut.percentOfDailyNeeds, specifier: "%.0f")%)")
                }
            }
            .padding()
        }
    }
}

struct RecipeRecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRecommendationView(fridgeVM: FridgeViewModel())
    }
}


