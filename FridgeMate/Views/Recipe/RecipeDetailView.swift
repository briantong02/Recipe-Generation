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
    @State private var isSummaryExpanded = false

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                //Image
                if let url = vm.detail?.image ?? recipe.imageURL {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color(.systemGray5)
                    }
                    .frame(height: 250)
                    .clipped()
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    // Recipe Title
                    if let error = vm.errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .font(.headline)
                            .padding(.horizontal)
                    } else {
                        Text(vm.detail?.title ?? "Loading...")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                    }
                    
                    // General recipe info
                    VStack(alignment: .leading, spacing: 16) {
                        // Cooking Time
                        if let time = vm.detail?.readyInMinutes {
                            Label {
                                Text("\(time) minutes")
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: "clock")
                                    .foregroundColor(.secondary)
                            }
                            
                            // Difficulty (derived from cooking time)
                            let difficulty: String = {
                                if time < 20 {
                                    return "Easy"
                                } else if time < 40 {
                                    return "Medium"
                                } else {
                                    return "Hard"
                                }
                            }()
                            
                            Label {
                                Text(difficulty)
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: "flame")
                                    .foregroundColor(.secondary)
                            }
                        }

                        // Servings
                        if let servings = vm.detail?.servings {
                            Label {
                                Text("\(servings) servings")
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: "person.2")
                                    .foregroundColor(.secondary)
                            }
                        }

                        // Diets
                        if let diets = vm.detail?.diets, !diets.isEmpty {
                            Label {
                                Text(diets.joined(separator: ", "))
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: "leaf")
                                    .foregroundColor(.secondary)
                            }
                        }

                        // Cuisine
                        if let cuisines = vm.detail?.cuisines, !cuisines.isEmpty {
                            Label {
                                Text(cuisines.joined(separator: ", "))
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: "globe")
                                    .foregroundColor(.secondary)
                            }
                        }

                        // Dish Types
                        if let types = vm.detail?.dishTypes, !types.isEmpty {
                            Label {
                                Text(types.joined(separator: ", "))
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: "fork.knife")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .font(.subheadline)
                    .padding(.horizontal)
                    
                    // Summary without HTML tags
//                    if let summary = vm.detail?.summary {
//                        Text(summary.replacingOccurrences(of: "<[^>]+>",
//                                                          with: "",
//                                                          options: .regularExpression))
//                            .font(.body)
//                            .foregroundColor(.secondary)
//                            .padding(.horizontal)
//                    }
//
                    // Summary Section
                    if let summary = vm.detail?.summary {
                        VStack(alignment: .leading, spacing: 8) {
                            // 토글 헤더
                            Button(action: {
                                withAnimation {
                                    isSummaryExpanded.toggle()
                                }
                            }) {
                                HStack {
                                    Text("Summary")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: isSummaryExpanded ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.gray)
                                }
                            }

                            // 토글된 내용
                            if isSummaryExpanded {
                                Text(summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .transition(.opacity)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Ingredients list
                    if let ingredients = vm.detail?.extendedIngredients {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Ingredients")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ForEach(ingredients, id: \.name) { ing in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("•")
                                        .foregroundColor(.secondary)
                                    Text(ing.original ?? ing.name)
                                        .foregroundColor(.primary)
                                }
                                .font(.body)
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Instructions
                    if let steps = vm.detail?.analyzedInstructions?.first?.steps {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Instructions")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ForEach(steps, id: \.number) { step in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("\(step.number)")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(width: 28, height: 28)
                                        .background(Color(.systemGray4))
                                        .clipShape(Circle())
                                    
                                    Text(step.step)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        // Nutrition info
                        if let nutrients = vm.detail?.nutrition?.nutrients {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Nutrition")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                ForEach(nutrients) { nut in
                                    HStack {
                                        Text(nut.name)
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Text(String(format: "%g%@", nut.amount, nut.unit))
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                   
                }
                .padding(8)
            }
        }
        .navigationTitle("Recipe Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let apiID = recipe.apiID {
                vm.loadDetail(id: apiID)
            }
            isSaved = recipeViewModel.isRecipeSaved(recipe)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") { dismiss() }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isSaved.toggle()
                    if isSaved {
                        recipeViewModel.saveRecipe(recipe)
                    } else {
                        recipeViewModel.removeRecipe(recipe)
                    }
                }) {
                    Image(systemName: isSaved ? "bookmark.fill": "bookmark")
                }
            }
        }
    }
}


