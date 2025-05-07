//
//  Recipe.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import Foundation

// MARK: - Internal Recipe Model
struct Recipe: Identifiable, Codable {
    let id: UUID
    var apiID: Int?
    var name: String
    var description: String
    var imageURL: URL?
    var sourceURL: URL?
    var cookingTime: Int
    var servings: Int?
    var difficulty: Difficulty
    var cuisine: Nationality
    var foodPreferences: [FoodPreference]
    var ingredients: [RecipeIngredient]
    var instructions: [String]
    
    // Primary initializer
    init(
        id: UUID = UUID(),
        apiID: Int? = nil,
        name: String,
        description: String,
        imageURL: URL? = nil,
        sourceURL: URL? = nil,
        cookingTime: Int,
        servings: Int? = nil,
        difficulty: Difficulty = .medium,
        cuisine: Nationality = .other,
        foodPreferences: [FoodPreference] = [],
        ingredients: [RecipeIngredient] = [],
        instructions: [String] = []
    ) {
        self.id = id
        self.apiID = apiID
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.sourceURL = sourceURL
        self.cookingTime = cookingTime
        self.servings = servings
        self.difficulty = difficulty
        self.cuisine = cuisine
        self.foodPreferences = foodPreferences
        self.ingredients = ingredients
        self.instructions = instructions
    }
}

// MARK: - Init from APIRecipe
extension Recipe {
    init(api: APIRecipe) {
        let mappedIngredients: [RecipeIngredient]
        if let ingredients = api.extendedIngredients {
            mappedIngredients = ingredients.map {
                RecipeIngredient(
                    name: $0.name,
                    amount: $0.amount,
                    unit: Unit(rawValue: $0.unit) ?? .gram,
                    isOptional: $0.original?.lowercased().contains("optional") ?? false
                )
            }
        } else {
            mappedIngredients = []
        }

        let mappedInstructions = api.analyzedInstructions?
            .first?.steps.map { $0.step } ?? []

        let cuisine = Nationality(rawValue: (api.cuisines?.first ?? "Other")) ?? .other
        let preferences = (api.diets ?? []).compactMap {
            FoodPreference(rawValue: $0.capitalized)
        }

        self.init(
            apiID: api.id,
            name: api.title,
            description: api.summary ?? "",
            imageURL: api.image,
            sourceURL: api.sourceUrl,
            cookingTime: api.readyInMinutes ?? 0,
            servings: api.servings,
            difficulty: .medium,
            cuisine: cuisine,
            foodPreferences: preferences,
            ingredients: mappedIngredients,
            instructions: mappedInstructions
        )
    }
}

// Represents one ingredient in a Recipe
struct RecipeIngredient: Identifiable, Codable {
    let id: UUID
    var name: String
    var amount: Double
    var unit: Unit
    var isOptional: Bool

    init(
        id: UUID = UUID(),
        name: String,
        amount: Double,
        unit: Unit,
        isOptional: Bool = false
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.unit = unit
        self.isOptional = isOptional
    }
}

// MARK: - Difficulty Enum
enum Difficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}
