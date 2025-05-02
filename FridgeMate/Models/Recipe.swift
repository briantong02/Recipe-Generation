//
//  Recipe.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var ingredients: [RecipeIngredient]
    var instructions: [String]
    var cookingTime: Int // in minutes
    var difficulty: Difficulty
    var cuisine: Nationality
    var foodPreferences: [FoodPreference]
    var allergens: [Allergy]
    var tags: [String]
    
    init(id: UUID = UUID(), name: String, description: String, ingredients: [RecipeIngredient], instructions: [String], cookingTime: Int, difficulty: Difficulty, cuisine: Nationality, foodPreferences: [FoodPreference], allergens: [Allergy], tags: [String]) {
        self.id = id
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.instructions = instructions
        self.cookingTime = cookingTime
        self.difficulty = difficulty
        self.cuisine = cuisine
        self.foodPreferences = foodPreferences
        self.allergens = allergens
        self.tags = tags
    }
}

struct RecipeIngredient: Identifiable, Codable {
    let id: UUID
    var name: String
    var amount: Double
    var unit: Unit
    var isOptional: Bool
    
    init(id: UUID = UUID(), name: String, amount: Double, unit: Unit, isOptional: Bool = false) {
        self.id = id
        self.name = name
        self.amount = amount
        self.unit = unit
        self.isOptional = isOptional
    }
}

enum Difficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

extension Recipe {
    init(api: APIRecipe) {
        // ingredients 변환
        let mappedIngredients = api.extendedIngredients.map { apiIng in
            RecipeIngredient(
                name: apiIng.name,
                amount: apiIng.amount,
                unit: Unit(rawValue: apiIng.unit) ?? .gram
            )
        }
        let steps = api.analyzedInstructions?
            .first?
            .steps
            .map { $0.step }
            ?? []
        
        let cuisine = Nationality(rawValue: api.cuisines.first ?? "Other") ?? .other
        
        let prefs = api.diets.compactMap { str in
            FoodPreference(rawValue: str.capitalized)
        }
        
        let tags = api.dishTypes
        
        self.init(
            name: api.title,
            description: api.summary ?? "",
            ingredients: mappedIngredients,
            instructions: steps,
            cookingTime: api.readyInMinutes,
            difficulty: .medium,
            cuisine: cuisine,
            foodPreferences: prefs,
            allergens: [],
            tags: tags
        )
    }
}
