//
//  APIRecipe.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 2/5/2025.
//

import Foundation

// Top-level wrapper for `/recipes/complexSearch` response
struct SpoonacularRecipeResponse: Codable {
    let results: [APIRecipe]
    let offset: Int?
    let number: Int?
    let totalResults: Int?
}

// Unified model covering both detail & ingredient-search results
struct APIRecipe: Codable {

    let id: Int
    let title: String
    let image: URL?

    let readyInMinutes: Int?
    let servings: Int?
    let summary: String?
    let cuisines: [String]?
    let dishTypes: [String]?
    let diets: [String]?
    let sourceUrl: URL?
    
    let extendedIngredients: [APIIngredient]?
    let analyzedInstructions: [APIInstruction]?
    let nutrition: APINutrition?
    
    let usedIngredientCount: Int?
    let missedIngredientCount: Int?
    let likes: Int?
    
    // CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, title, image,
             readyInMinutes, servings, summary, cuisines, dishTypes, diets,
             sourceUrl, extendedIngredients, analyzedInstructions, nutrition,
             usedIngredientCount, missedIngredientCount, likes
    }
}

struct APIIngredient: Codable {
    let name: String
    let original: String?
    let amount: Double
    let unit: String
}

struct APIInstruction: Codable {
    let steps: [APIInstructionStep]
}

struct APIInstructionStep: Codable {
    let number: Int
    let step: String
}

struct APINutrition: Codable {
    let nutrients: [APINutrient]
}

struct APINutrient: Codable, Identifiable {
    var id: String { name }
    let name: String
    let amount: Double
    let unit: String
}
