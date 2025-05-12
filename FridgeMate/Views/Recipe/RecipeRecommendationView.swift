//
//  RecipeRecommendationView.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import SwiftUI
import Combine

// Int becomes Identifiable for sheet presentation
extension Int: Identifiable { public var id: Int { self } }

// Class to store cancellables (structs can't mutate self properties in methods)
class CancellableStore {
    var cancellables = Set<AnyCancellable>()
}

struct RecipeRecommendationView: View {
    @ObservedObject var fridgeVM: FridgeViewModel
    @ObservedObject var vm: RecipeRecommendationViewModel
    @State private var selectedRecipe: Recipe?
    @State private var retryCount = 0
    
    // Use a class instance to store cancellables
    private let cancellableStore = CancellableStore()
    
    var body: some View {
        VStack(spacing: 0) {
            RecipeFilterView(
                selectedCookingTime: $vm.selectedCookingTime,
                onFilter: {
                    loadRecipes()
                }
            )
            
            if vm.isLoading {
                Spacer()
                VStack {
                    ProgressView("Loading recipes...")
                    Text("This may take a moment...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
                Spacer()
            } else if let error = vm.errorMessage {
                Spacer()
                VStack(spacing: 16) {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button(action: loadRecipes) {
                        Label("Try Again", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.bordered)
                }
                Spacer()
            } else if vm.recipes.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Text("No recipes found")
                        .font(.headline)
                    
                    Text("Try adding more ingredients to your fridge or changing the filter")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: loadRecipes) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.bordered)
                }
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
        .navigationTitle("Recipe")
        .toolbar {
            Button(action: loadRecipes) {
                Image(systemName: "arrow.clockwise")
            }
        }
        .onAppear {
            loadRecipes()
        }
        .onChange(of: fridgeVM.ingredients) { oldList, newList in
            print("🍽 old:", oldList.map(\.name))
            print("🍽 new:", newList.map(\.name))
            loadRecipes()
        }
        .sheet(item: $selectedRecipe) { recipe in
            NavigationStack {
                RecipeDetailView(recipe: recipe, recipeViewModel: vm)
            }
        }
    }
    
    private func loadRecipes() {
        retryCount += 1
        print("📲 Loading recipes (attempt \(retryCount))")
        
        // First test API connectivity using the completion handler
        RecipeService.shared.testAPIConnectivity { isConnected in
            if isConnected {
                print("✅ API connectivity test passed, loading recipes...")
                self.vm.loadRecipes(from: self.fridgeVM.ingredients)
            } else {
                print("❌ API connectivity test failed")
                self.vm.isLoading = false
                self.vm.errorMessage = "Cannot connect to recipe service. Please check your internet connection and try again."
            }
        }
    }
}
