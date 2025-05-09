//
//  Ingredient.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import Foundation

struct Ingredient: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var category: IngredientCategory
    var amount: Double
    var unit: Unit
    var expiryDate: Date?
    var addedDate: Date

    init(
        id: UUID = UUID(),
        name: String,
        category: IngredientCategory,
        amount: Double,
        unit: Unit,
        expiryDate: Date? = nil,
        addedDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.amount = amount
        self.unit = unit
        self.expiryDate = expiryDate
        self.addedDate = addedDate
    }
}

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

// Convert from APIIngredient to app Ingredient
extension Ingredient {
    init(api: APIIngredient) {
        self.init(
            name: api.name,
            category: .other,
            amount: api.amount,
            unit: Unit(rawValue: api.unit) ?? .gram
        )
    }
}

