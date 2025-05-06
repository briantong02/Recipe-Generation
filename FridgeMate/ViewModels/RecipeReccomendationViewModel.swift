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
    
    @Published var savedRecipes: [Recipe] = []
    
    private let fileURL: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("saved_recipes.json")
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSavedRecipes()
    }
    
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
    
    func saveRecipe(_ recipe: Recipe) {
        if !savedRecipes.contains(where: { $0.id == recipe.id }) {
            savedRecipes.append(recipe)
            persistSavedRecipes()
        }
    }
    
    func removeRecipe(_ recipe: Recipe) {
        savedRecipes.removeAll { $0.id == recipe.id }
        persistSavedRecipes()
    }
    
    func isRecipeSaved(_ recipe: Recipe) -> Bool {
        savedRecipes.contains(where: { $0.id == recipe.id })
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

