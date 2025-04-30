//
//  FridgeViewModel.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import Foundation
import SwiftUI

class FridgeViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    @Published var userPreferences: UserPreferences
    @Published var recommendedRecipes: [Recipe] = []
    
    
    init() {
        // Initialize with default preferences
        self.userPreferences = UserPreferences(
            nationality: .korean,
            preferences: [],
            allergies: []
        )
        
    }
        
    func addIngredients(_ newItems: [Ingredient]) {
            ingredients.append(contentsOf: newItems)
    }
        
    func addIngredient(_ ingredient: Ingredient) {
            ingredients.append(ingredient)
    }
        
    func removeIngredient(_ ingredient: Ingredient) {
            ingredients.removeAll { $0.id == ingredient.id }
    }
        
    func updateUserPreferences(_ preferences: UserPreferences) {
        userPreferences = preferences
    }
        
    func findRecipes() {
            // This is a placeholder for the actual recipe matching logic
            // In a real app, this would:
            // 1. Filter recipes based on user preferences and allergies
            // 2. Match recipes with available ingredients
            // 3. Sort recipes into tiers based on ingredient matching
            // 4. Update recommendedRecipes
    }
        
    func getRecipeTiers() -> [RecipeTier] {
            // This would be implemented to categorize recipes into tiers
            // based on ingredient matching
        return []
    }
}

enum RecipeTier {
    case tier1 // All ingredients available
    case tier2 // Most ingredients available, some substitutions needed
    case tier3 // Missing 1-2 ingredients
}
