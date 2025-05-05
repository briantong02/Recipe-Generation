//
//  RecipeRecommendationView.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import SwiftUI

/// Make Int optional usable with .sheet(item:)
extension Int: Identifiable {
    public var id: Int { self }
}

/// Shows a list of recipe recommendations based on fridge ingredients.
struct RecipeRecommendationView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @StateObject private var recipeVM = RecipeRecommendationViewModel()
    @State private var selectedRecipeID: Int? = nil

    var body: some View {
        NavigationView {
            Group {
                if recipeVM.isLoadingList {
                    ProgressView("Loading recipes…")
                        .padding()
                } else if let err = recipeVM.errorMessage {
                    Text("Error: \(err)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List(recipeVM.recipes) { recipe in
                        Button(action: { selectedRecipeID = recipe.id }) {
                            HStack(alignment: .top, spacing: 16) {
                                AsyncImage(url: URL(string: recipe.image)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        Color.gray
                                    }
                                }
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)

                                VStack(alignment: .leading, spacing: 8) {
                                    Text(recipe.title)
                                        .font(.headline)
                                        .lineLimit(2)
                                    if let time = recipe.readyInMinutes {
                                        Text("⏱ \(time) min")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Recommendations")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { recipeVM.findRecipes(from: viewModel.ingredients) }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .onAppear {
                recipeVM.findRecipes(from: viewModel.ingredients)
            }
            .sheet(item: $selectedRecipeID) { id in
                RecipeDetailView(recipeID: id)
            }
        }
    }
}
