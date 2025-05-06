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
    @StateObject private var vm = RecipeRecommendationViewModel()
    @State private var selectedRecipeID: Int?
    @State private var isFiltering = false

    var body: some View {
        VStack(spacing: 0) {
            RecipeFilterView(
                selectedCookingTime: $vm.selectedCookingTime,
                isFiltering: $isFiltering,
                onFilter: {
                    vm.loadRecipes(from: fridgeVM.ingredients)
                }
            )
            .background(Color(.systemBackground))
            
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
                    Button(action: { selectedRecipeID = recipe.apiID ?? recipe.id.hashValue }) {
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
        .sheet(item: $selectedRecipeID) { id in
            RecipeDetailView(recipeID: id)
        }
    }
}
