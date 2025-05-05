//
//  Recipe.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import Foundation

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
    var allergens: [Allergy]
    var tags: [String]
    var ingredients: [RecipeIngredient]
    var instructions: [String]

    init(
        id: UUID = UUID(),
        apiID: Int? = nil,
        name: String,
        description: String,
        imageURL: URL? = nil,
        sourceURL: URL? = nil,
        cookingTime: Int,
        servings: Int? = nil,
        difficulty: Difficulty,
        cuisine: Nationality,
        foodPreferences: [FoodPreference],
        allergens: [Allergy],
        tags: [String],
        ingredients: [RecipeIngredient],
        instructions: [String]
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
        self.allergens = allergens
        self.tags = tags
        self.ingredients = ingredients
        self.instructions = instructions
    }
}

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

enum Difficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

// Convert from APIRecipe to app Recipe
extension Recipe {
    init(api: APIRecipe) {
        // Map ingredients
        let mappedIngredients = api.extendedIngredients.map { apiIng in
            RecipeIngredient(
                name: apiIng.name,
                amount: apiIng.amount,
                unit: Unit(rawValue: apiIng.unit) ?? .gram
            )
        }
        // Map instructions (first instruction group's steps)
        let steps = api.analyzedInstructions?
            .first?
            .steps
            .map { $0.step } ?? []
        // Map URLs
        let imageURL = api.image.flatMap(URL.init(string:))
        let sourceURL = api.sourceUrl.flatMap(URL.init(string:))
        // Map cuisine/diets/dishTypes
        let cuisine = Nationality(rawValue: api.cuisines.first ?? "Other") ?? .other
        let prefs = api.diets.compactMap { FoodPreference(rawValue: $0.capitalized) }
        // Initialize
        self.init(
            apiID: api.id,
            name: api.title,
            description: api.summary ?? "",
            imageURL: imageURL,
            sourceURL: sourceURL,
            cookingTime: api.readyInMinutes,
            servings: api.servings,
            difficulty: .medium,
            cuisine: cuisine,
            foodPreferences: prefs,
            allergens: [],
            tags: api.dishTypes,
            ingredients: mappedIngredients,
            instructions: steps
        )
    }
}
