//
//  SavedRecipeView.swift
//  FridgeMate
//
//  Created by Rujeet Prajapati on 06/05/2025.
//

import SwiftUI

struct SavedRecipeView: View {
    @ObservedObject var viewModel: RecipeRecommendationViewModel
    @State private var selectedRecipe: Recipe? = nil
    
    var body: some View {
        Group {
            if(viewModel.savedRecipes.isEmpty){
                Text("No Saved Recipes yet.").font(.body)
                    .foregroundColor(.gray)
            }else{
                List(viewModel.savedRecipes) { recipe in
                    HStack {
                        Button(action: { selectedRecipe = recipe }) {
                            HStack {
                                AsyncImage(url: recipe.imageURL) { phase in
                                    if let img = phase.image {
                                        img.resizable().scaledToFill()
                                    } else { Color.gray }
                                }
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                                VStack(alignment: .leading) {
                                    Text(recipe.name).font(.headline).lineLimit(2)
                                    Text("⏱ \(recipe.cookingTime) min")
                                        .font(.subheadline).foregroundColor(.secondary)
                                }
                            }
                        }
                        Spacer()
                        Button(action: {
                            viewModel.removeRecipe(recipe)
                        }) {
                            Image(systemName: viewModel.isRecipeSaved(recipe) ? "bookmark.fill" : "bookmark")
                                .foregroundColor(viewModel.isRecipeSaved(recipe) ? .blue : .gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .listStyle(PlainListStyle())
            }
        }.navigationTitle("Saved Recipies")
            .sheet(item: $selectedRecipe) { recipe in
                NavigationStack {
                    RecipeDetailView(recipe: recipe, recipeViewModel: viewModel)
                }
            }
    }
}

#Preview {
    SavedRecipeView(
        viewModel: RecipeRecommendationViewModel()
    )
}
