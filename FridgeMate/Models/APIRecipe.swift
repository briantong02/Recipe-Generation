//
//  APIRecipe.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 2/5/2025.
//

import Foundation


struct SpoonacularRecipeResponse: Codable {
    let results: [APIRecipe]
    let number: Int
    let offset: Int
    let totalResults: Int
}

// Recipe
struct APIRecipe: Codable {
    let id: Int
    let title: String
    let summary: String?
    let image: String?
    let readyInMinutes: Int
    let servings: Int
    let cuisines: [String]
    let dishTypes: [String]
    let diets: [String]
    let sourceUrl: String?
    let extendedIngredients: [APIIngredient]
    let analyzedInstructions: [APIInstruction]?
}

// Instruction
struct APIInstruction: Codable {
    let name: String?
    let steps: [APIInstructionStep]
}

// InstructionStep
struct APIInstructionStep: Codable {
    let number: Int
    let step: String
}

