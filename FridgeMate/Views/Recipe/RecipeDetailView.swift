//
//  RecipeDetailView.swift
//  FridgeMate
//
//  Created by Hai Tong on 4/5/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @ObservedObject var recipeViewModel: RecipeRecommendationViewModel
    @StateObject private var vm = RecipeDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var isSaved: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Recipe image
                    if let url = vm.detail?.image {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Color(.systemGray5)
                        }
                        .frame(height: 250).clipped()
                    }
                    
                    // Title
                    Text(vm.detail?.title ?? "Loading...")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                    
                    // Summary
                    
                    if let summary = vm.detail?.summary {
                        Text(summary.replacingOccurrences(of: "<[^>]+>",
                                                          with: "",
                                                          options: .regularExpression))
                        .padding(.horizontal)
                    }
                    
                    Divider().padding(.horizontal)
                    
                    // Ingredients list
                    if let ingredients = vm.detail?.extendedIngredients {
                        VStack(alignment: .leading) {
                            Text("Ingredients")
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)
                            ForEach(ingredients, id: \.name) { ing in
                                Text("• \(ing.original ?? ing.name)")
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    Divider().padding(.horizontal)
                    
                    // Instruction
                    if let steps = vm.detail?.analyzedInstructions?.first?.steps {
                        VStack(alignment: .leading) {
                            Text("Instructions")
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)
                            ForEach(steps, id: \.number) { step in
                                Text("\(step.number). \(step.step)")
                                    .padding(.horizontal)
                            }
                        }
                        
                        Divider().padding(.horizontal)
                        
                        // Nutrition info
                        if let nutrients = vm.detail?.nutrition?.nutrients {
                            VStack(alignment: .leading) {
                                Text("Nutrition")
                                    .font(.title2)
                                    .bold()
                                    .padding(.horizontal)
                                ForEach(nutrients) { nut in
                                    HStack {
                                        Text(nut.name)
                                            .font(.subheadline).bold()
                                        Spacer()
                                        Text(String(format: "%g%@", nut.amount, nut.unit))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .onAppear {
                vm.loadDetail(id: recipe.apiID!)
                isSaved = recipeViewModel.isRecipeSaved(recipe)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Back") { dismiss() },
                trailing: Button(action: {
                    isSaved.toggle()
                    if isSaved {
                        recipeViewModel.saveRecipe(recipe)
                    } else {
                        recipeViewModel.removeRecipe(recipe)
                    }
                }){
                    Image(systemName: isSaved ? "bookmark.fill": "bookmark")
                }
            )
        }
    }
}

