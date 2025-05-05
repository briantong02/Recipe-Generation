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
    
    init(recipeID: Int) { self.recipeID = recipeID }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imgUrl = vm.detail?.image, let url = URL(string: imgUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color(.systemGray5)
                    }
                    .frame(height: 250).clipped()
                }

                Text(vm.detail?.title ?? "Loading...")
                    .font(.largeTitle).bold().padding(.horizontal)

                if let summary = vm.detail?.summary {
                    Text(summary.replacingOccurrences(of: "<[^>]+>",
                                                       with: "",
                                                       options: .regularExpression))
                        .padding(.horizontal)
                }

                Divider().padding(.horizontal)

                if let ingredients = vm.detail?.extendedIngredients {
                    VStack(alignment: .leading) {
                        Text("Ingredients").font(.title2).bold().padding(.horizontal)
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
                            .font(.title2).bold().padding(.horizontal)
                        ForEach(steps, id: \.number) { step in
                            Text("\(step.number). \(step.step)")
                            .padding(.horizontal)
                    }
                }

                Divider().padding(.horizontal)

                // Nutrition
                if let nutrients = vm.detail?.nutrition?.nutrients {
                    VStack(alignment: .leading) {
                        Text("Nutrition")
                            .font(.title2).bold().padding(.horizontal)
                        ForEach(nutrients) { nut in
                            HStack {
                                Text(nut.name)
                                    .font(.subheadline).bold()
                                Spacer()
                                Text(String(format: "%g%@", nut.amount, nut.unit))
                                    .font(.caption).foregroundColor(.secondary)
                            }
                            .padding().background(Color(.systemGray6)).cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear { vm.loadDetail(id: recipeID) }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
