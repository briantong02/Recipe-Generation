//
//  Ingredient.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import Foundation

//struct Ingredient: Identifiable, Codable {
//    let id: UUID
//    var name: String
//    var category: IngredientCategory
//    var amount: Double
//    var unit: Unit
//    var expiryDate: Date?
//    
//    init(id: UUID = UUID(), name: String, category: IngredientCategory, amount: Double, unit: Unit, expiryDate: Date? = nil) {
//        self.id = id
//        self.name = name
//        self.category = category
//        self.amount = amount
//        self.unit = unit
//        self.expiryDate = expiryDate
//    }
//}

enum IngredientCategory: String, Codable, CaseIterable {
    case meat = "Meat"
    case vegetable = "Vegetable"
    case fruit = "Fruit"
    case dairy = "Dairy"
    case grain = "Grain"
    case spice = "Spice"
    case sauce = "Sauce"
    case other = "Other"
}

enum Unit: String, Codable, CaseIterable {
    case gram = "g"
    case kilogram = "kg"
    case milliliter = "ml"
    case liter = "L"
    case piece = "piece"
    case cup = "cup"
    case tablespoon = "tbsp"
    case teaspoon = "tsp"
    case bunch = "bunch"
}

struct Ingredient: Codable {
    let id: Int
    let original, originalName, name: String
    let possibleUnits: [String]
    let consistency: String
    let shoppingListUnits: [String]
    let aisle, image: String
    let meta: [String]
    let categoryPath: [String]
}

struct IngredientSearchResult: Codable {
    let results: [Ingredient]
}
