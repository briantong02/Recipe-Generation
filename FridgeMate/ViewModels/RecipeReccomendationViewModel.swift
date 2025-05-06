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
        guard !ingredients.isEmpty else {
            self.recipes = []
            return
        }

        let ingredientNames = ingredients.map { $0.name }

        isLoading = true
        errorMessage = nil

        // Step 1: fetch simplified recipe results
        RecipeService.shared.fetchRecipes(query: ingredientNames)
            .flatMap { simpleResults -> AnyPublisher<[Recipe], Error> in
                let ids = simpleResults.compactMap { $0.id }
                guard !ids.isEmpty else {
                    return Just([])
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                // Step 2: bulk fetch full info for these IDs
                return RecipeService.shared.fetchBulkRecipeDetails(ids: ids)
                    .map { fullDetails in
                        fullDetails.map { Recipe(api: $0) }
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { [weak self] completion in
                print("📡 completion:", completion)
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] recipes in
                print("✅ received \(recipes.count) recipes")

                self?.recipes = recipes
            })
            .store(in: &cancellables)
    }
}
