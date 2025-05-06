//
//  RecipeDetailView.swift
//  FridgeMate
//
//  Created by Hai Tong on 4/5/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipeID: Int
    @StateObject private var vm = RecipeDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    init(recipeID: Int) {
        self.recipeID = recipeID
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Close button at the top
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
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
                    
                    // Recipe Title
                    if let error = vm.errorMessage {
                        Text("❌ Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        Text(vm.detail?.title ?? "Loading...")
                            .font(.largeTitle)
                            .bold()
                            .padding(.horizontal)
                    }
                    
                    // Summary without HTML tags
                    if let summary = vm.detail?.summary {
                        Text(summary.replacingOccurrences(of: "<[^>]+>",
                                                          with: "",
                                                          options: .regularExpression))
                        .padding(.horizontal)
                    }
                    
                    Divider().padding(.horizontal)
                    
                    // General recipe info
                    VStack(alignment: .leading, spacing: 6) {

                        // Cooking Time
                        if let time = vm.detail?.readyInMinutes {
                            Text("⏱ Cooking Time: \(time) min")
                            
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
                            
                            Text("🔥 Difficulty: \(difficulty)")
                        }

                        // Servings
                        if let servings = vm.detail?.servings {
                            Text("🍽 Servings: \(servings)")
                        }

                        // Diets
                        if let diets = vm.detail?.diets, !diets.isEmpty {
                            Text("🧬 Diets: \(diets.joined(separator: ", "))")
                        }

                        // Cuisine
                        if let cuisines = vm.detail?.cuisines, !cuisines.isEmpty {
                            Text("🌍 Cuisine: \(cuisines.joined(separator: ", "))")
                        }

                        // Dish Types
                        if let types = vm.detail?.dishTypes, !types.isEmpty {
                            Text("🍱 Dish Types: \(types.joined(separator: ", "))")
                        }
                    }
                    .font(.subheadline)
                    .padding(.horizontal)

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
                vm.loadDetail(id: recipeID)
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
