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
    // MARK: - Common fields
    let id: Int
    let title: String
    let image: URL?
    
    // MARK: - Fields returned by `/recipes/complexSearch?addRecipeInformation=true`
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
    
    // MARK: - Fields returned by `/recipes/findByIngredients`
    let usedIngredientCount: Int?
    let missedIngredientCount: Int?
    let likes: Int?
}

// MARK: - CodingKeys
enum CodingKeys: String, CodingKey {
    case id, title, image
      
    // complexSearch
    case readyInMinutes,
        servings,
        summary,
        cuisines,
        dishTypes,
        diets
    case sourceURL = "sourceUrl"
    case extendedIngredients,
        analyzedInstructions,
        nutrition
          
    // findByIngredients
    case usedIngredientCount,
         missedIngredientCount,
         likes
}

struct APIIngredient: Codable {
    let id: Int?
    let name: String
    let original: String?
    let aisle: String?
    let amount: Double
    let unit: String
    let measures: Measures?
}

struct Measures: Codable {
    let us: MeasureDetail?
    let metric: MeasureDetail?
}

struct MeasureDetail: Codable {
    let amount: Double?
    let unitShort: String?
    let unitLong: String?
}

struct APIInstruction: Codable {
    let name: String?
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
