//
//  RecipeReccomendationViewModel.swift
//  FridgeMate
//
//  Created by Hai Tong on 4/5/25.
//

// RecipeRecommendationViewModel.swift
// Integrates Spoonacular API calls for recipe recommendations and details

import Foundation
import Combine

// ViewModel for recipe recommendation list
class RecipeRecommendationViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    // Load recipes based on fridge ingredients
    func loadRecipes(from ingredients: [Ingredient]) {
        print("⚙️ loadRecipes called with:", ingredients.map(\.name))
        let names = ingredients.map { $0.name }
        isLoading = true
        errorMessage = nil

        RecipeService.shared
            .fetchRecipes(query: names)
            .map { apiList in apiList.map(Recipe.init(api:)) }
            .sink { [weak self] completion in
                print("📡 completion:", completion)
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] recipes in
                print("✅ received \(recipes.count) recipes")
                self?.recipes = recipes
              }
            .store(in: &cancellables)
    }
}

