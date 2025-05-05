//
//  APIRecipe.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 2/5/2025.
//

import Foundation

struct SpoonacularRecipeResponse: Codable {
    let results: [APIRecipe]
    let offset: Int?
    let number: Int?
    let totalResults: Int?
}

struct APIRecipe: Codable {
    let id: Int
    let title: String
    let image: String?
    let readyInMinutes: Int
    let servings: Int?
    let summary: String?
    let cuisines: [String]
    let dishTypes: [String]
    let diets: [String]
    let sourceUrl: String?
    let extendedIngredients: [APIIngredient]
    let analyzedInstructions: [APIInstruction]?
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
