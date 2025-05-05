//
//  FridgeViewModel.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import Foundation
import Combine

// ViewModel managing fridge ingredients and recipe recommendations
class FridgeViewModel: ObservableObject {
    // MARK: - Published properties for SwiftUI bindings

    // The list of ingredients the user has in their fridge
    @Published var ingredients: [Ingredient] = []

    // The user’s saved preferences (cuisine, allergies, etc.)
    @Published var userPreferences: UserPreferences

    // Recipes recommended based on the current fridge contents
    @Published var recommendedRecipes: [Recipe] = []

    // Loading state for recipe fetch
    @Published var isLoading: Bool = false

    // Any error message from the last fetch
    @Published var errorMessage: String?

    // MARK: - Private

    // Store Combine subscriptions
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init() {
        // Initialize with reasonable defaults
        self.userPreferences = UserPreferences(
            nationality: .other,
            preferences: [],
            allergies: [],
            cookingSkillLevel: .beginner,
            cookingTools: [],
            maxPrepTime: .quick
        )
    }

    // MARK: - Ingredient Management

    // Add a single ingredient to the fridge
    func addIngredient(_ ingredient: Ingredient) {
        ingredients.append(ingredient)
    }
    
    // Add multiple ingredients at once
    func addIngredients(_ newItems: [Ingredient]) {
        print("🧩 addIngredients called with:", newItems.map(\.name))
        ingredients.append(contentsOf: newItems)
        findRecipes()
    }

    // Remove an ingredient by id
    func removeIngredients(_ ingredient: Ingredient) {
        ingredients.removeAll { $0.id == ingredient.id }
        findRecipes()
    }

    // Clear all ingredients
    func clearIngredients() {
        ingredients.removeAll()
    }

    // MARK: - User Preferences

    // Update the user’s cuisine/allergy preferences
    func updateUserPreferences(_ preferences: UserPreferences) {
        userPreferences = preferences
    }

    // MARK: - Recipe Recommendation

    // Fetch recommendations from Spoonacular based on current `ingredients`
    func findRecipes() {
        // 1. Prepare query string (comma-separated names)
        let queryNames = ingredients.map(\.name)
        guard !queryNames.isEmpty else {
            // If no ingredients, clear results and return
            recommendedRecipes = []
            return
        }

        // 2. Update loading state
        isLoading = true
        errorMessage = nil

        // 3. Call the shared RecipeService
        RecipeService.shared
            .fetchRecipes(query: queryNames)
            // 4. Map APIRecipe → internal Recipe model
            .map { apiRecipes in
                apiRecipes.map { Recipe(api: $0) }
            }
            // 5. Switch back to main thread
            .receive(on: DispatchQueue.main)
            // 6. Handle success & failure
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case let .failure(error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] recipes in
                    self?.recommendedRecipes = recipes
                }
            )
            .store(in: &cancellables)
    }
}

