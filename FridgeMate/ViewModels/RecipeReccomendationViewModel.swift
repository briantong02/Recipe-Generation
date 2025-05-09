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
    
    init() {
        loadSavedRecipes()
    }
    
    // Load recipes based on fridge ingredients
    func loadRecipes(from ingredients: [Ingredient]) {
        // 재료가 바뀌지 않았다면 API 호출하지 않음
        if ingredients == lastIngredients && !recipes.isEmpty {
            return
        }
        lastIngredients = ingredients
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
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                print("📡 completion:", completion)
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] recipes in
                print("✅ received \(recipes.count) recipes")
                
                // Filter recipes based on cooking time
                if let self = self {
                    self.recipes = recipes.filter { recipe in
                        self.selectedCookingTime.matches(recipe.cookingTime)
                    }
                }
            })
            .store(in: &cancellables)
    }
    
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
    
    private func persistSavedRecipes() {
        do {
            let data = try JSONEncoder().encode(savedRecipes)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save recipes: \(error)")
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

