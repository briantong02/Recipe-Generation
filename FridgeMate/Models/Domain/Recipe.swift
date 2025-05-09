//
//  Recipe.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import Foundation

// The app’s internal recipe model
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
    var tags: [String]
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
        difficulty: Difficulty,
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
        self.tags = tags
        self.ingredients = ingredients
        self.instructions = instructions
    }
}

// Maps an APIRecipe (from Spoonacular) into the app’s Recipe
extension Recipe {
    // Initialize internal Recipe from APIRecipe
    init(api: APIRecipe) {
        // 1. Map ingredients
        let mappedIngredients = (api.extendedIngredients ?? []).map { ing in
            RecipeIngredient(
                name: ing.name,
                amount: ing.amount,
                unit: Unit(rawValue: ing.unit) ?? .gram,
                isOptional: ing.original?.lowercased().contains("optional") ?? false
            )
        }

        // 2. Map instructions (first group’s steps)
        let mappedInstructions: [String] = api.analyzedInstructions?
            .first?
            .steps
            .map { $0.step } ?? []

        // 3. Convert image/source URLs
        let imageURL: URL?     = api.image
        let sourceURL: URL?    = api.sourceUrl

        // 4. optional string arrays
       
        let tags = api.dishTypes ?? []

        let cookingTime = api.readyInMinutes ?? 0

        // 5. Intialize recipe
        self.init(
            apiID: api.id,
            name: api.title,
            description: api.summary ?? "",
            imageURL: imageURL,
            sourceURL: sourceURL,
            cookingTime: cookingTime,
            servings: api.servings,
            difficulty: .medium,
            tags: tags,
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

// Difficulty levels (you can expand/use user preferences)
enum Difficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}
