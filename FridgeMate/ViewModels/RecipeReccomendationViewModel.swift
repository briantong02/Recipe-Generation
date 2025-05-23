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
    @Published var selectedCookingTime: CookingTimeFilter = .all
    @Published var savedRecipes: [Recipe] = []
    
    private let fileURL: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("saved_recipes.json")
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var lastIngredients: [Ingredient] = []
    private var lastCookingTimeFilter: CookingTimeFilter = .all
    
    init() {
        loadSavedRecipes()
    }
    
    // Load recipes based on ingredients
    func loadRecipes(from ingredients: [Ingredient]) {
        // Skip API call if ingredients haven't changed, filter hasn't changed, and we have recipes
        if ingredients == lastIngredients && selectedCookingTime == lastCookingTimeFilter && !recipes.isEmpty {
            return
        }
        
        lastIngredients = ingredients
        lastCookingTimeFilter = selectedCookingTime
        print("⚙️ Loading recipes for ingredients:", ingredients.map(\.name))
        
        guard !ingredients.isEmpty else {
            self.recipes = []
            return
        }

        let ingredientNames = ingredients.map { $0.name }
        isLoading = true
        errorMessage = nil

        // First fetch basic recipe info
        RecipeService.shared.fetchRecipes(query: ingredientNames)
            .flatMap { simpleResults -> AnyPublisher<[Recipe], Error> in
                print("📊 Found \(simpleResults.count) simple results")
                let ids = simpleResults.compactMap { $0.id }
                guard !ids.isEmpty else {
                    return Just([])
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                // Then fetch detailed info for each recipe
                return RecipeService.shared.fetchBulkRecipeDetails(ids: ids)
                    .map { fullDetails in
                        print("📊 Received \(fullDetails.count) detailed recipes")
                        return fullDetails.map { Recipe(api: $0) }
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        print("❌ Recipe loading failed:", error.localizedDescription)
                        // Provide more user-friendly error message
                        if let urlError = error as? URLError {
                            switch urlError.code {
                            case .timedOut:
                                self?.errorMessage = "Connection timed out. Please try again."
                            case .notConnectedToInternet:
                                self?.errorMessage = "No internet connection. Please check your network."
                            default:
                                self?.errorMessage = "Network error: \(urlError.localizedDescription)"
                            }
                        } else {
                            self?.errorMessage = error.localizedDescription
                        }
                    }
                },
                receiveValue: { [weak self] receivedRecipes in
                    guard let self = self else { return }
                    print("✅ Received \(receivedRecipes.count) recipes")
                    
                    // Store all unfiltered recipes
                    self.allRecipes = receivedRecipes
                    
                    // Apply cooking time filter
                    self.recipes = receivedRecipes.filter { recipe in
                        self.selectedCookingTime.matches(recipe.cookingTime)
                    }
                    
                    if self.recipes.isEmpty && !receivedRecipes.isEmpty {
                        // We have recipes but they're all filtered out
                        print("⚠️ All recipes filtered out by cooking time filter")
                    } else {
                        print("✅ Successfully loaded \(self.recipes.count) recipes after filtering")
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Saved Recipes Management
    
    func saveRecipe(_ recipe: Recipe) {
        if !isRecipeSaved(recipe) {
            savedRecipes.append(recipe)
            persistSavedRecipes()
        }
    }
    
    func removeRecipe(_ recipe: Recipe) {
        savedRecipes.removeAll { $0.id == recipe.id }
        persistSavedRecipes()
    }
    
    func isRecipeSaved(_ recipe: Recipe) -> Bool {
        savedRecipes.contains { saved in
            if let apiID = recipe.apiID, let savedApiID = saved.apiID {
                return apiID == savedApiID
            } else {
                return recipe.id == saved.id
            }
        }
    }
    
    // MARK: - Filtering
    
    // Store original unfiltered recipes
    private(set) var allRecipes: [Recipe] = []
    
    // Apply the current cooking time filter to already loaded recipes
    func applyCurrentFilter() {
        guard !lastIngredients.isEmpty else { return }
        
        print("🔍 Applying filter: \(selectedCookingTime.rawValue)")
        
        // If we don't have any recipes or filter changed and we need to reload from API
        if (recipes.isEmpty && allRecipes.isEmpty) || (selectedCookingTime != lastCookingTimeFilter && allRecipes.isEmpty) {
            // Force reload by setting lastCookingTimeFilter to current filter
            lastCookingTimeFilter = selectedCookingTime
            loadRecipes(from: lastIngredients)
            return
        }
        
        // We have recipes, just apply the filter to existing recipes
        if !allRecipes.isEmpty {
            // Update the last filter to the current one
            lastCookingTimeFilter = selectedCookingTime
            
            // Apply filter to all recipes
            recipes = allRecipes.filter { recipe in
                selectedCookingTime.matches(recipe.cookingTime)
            }
            
            if recipes.isEmpty && !allRecipes.isEmpty {
                print("⚠️ All recipes filtered out by cooking time filter")
            } else {
                print("✅ Applied filter: \(selectedCookingTime.rawValue), showing \(recipes.count) recipes")
            }
        }
    }
    
    private func persistSavedRecipes() {
        do {
            let data = try JSONEncoder().encode(savedRecipes)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save recipes:", error)
        }
    }
    
    private func loadSavedRecipes() {
        do {
            let data = try Data(contentsOf: fileURL)
            savedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
        } catch {
            savedRecipes = []
        }
    }
}

