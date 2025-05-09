//
//  RecipeRecommendationView.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import SwiftUI

// Int becomes Identifiable for sheet presentation
extension Int: Identifiable { public var id: Int { self } }

struct RecipeRecommendationView: View {
    @ObservedObject var fridgeVM: FridgeViewModel
    @ObservedObject var vm : RecipeRecommendationViewModel
    @State private var selectedRecipe: Recipe?

    var body: some View {
        VStack(spacing: 0) {
            // Recommendation 제목 아래에 항상 고정
            RecipeFilterView(
                selectedCookingTime: $vm.selectedCookingTime,
                onFilter: {
                    vm.loadRecipes(from: fridgeVM.ingredients)
                }
            )
            
            if vm.isLoading {
                Spacer()
                ProgressView("Loading recipes...")
                Spacer()
            } else if let error = vm.errorMessage {
                Spacer()
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            } else {
                List(vm.recipes) { recipe in
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
                            Spacer()
                            Image(systemName: vm.isRecipeSaved(recipe) ? "bookmark.fill" : "bookmark")
                                .foregroundColor(vm.isRecipeSaved(recipe) ? .blue : .gray)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Recommendations")
        .toolbar {
            Button { vm.loadRecipes(from: fridgeVM.ingredients) }
            label: { Image(systemName: "arrow.clockwise") }
        }
        .onAppear {
            vm.loadRecipes(from: fridgeVM.ingredients)
        }
        .onChange(of: fridgeVM.ingredients) { oldList, newList in
            print("🍽 old:", oldList.map(\.name))
            print("🍽 new:", newList.map(\.name))
            vm.loadRecipes(from: newList)
        }
        .sheet(item: $selectedRecipe) { recipe in
            NavigationStack {
                RecipeDetailView(recipe: recipe, recipeViewModel: vm)
            }
        }
    }
}
