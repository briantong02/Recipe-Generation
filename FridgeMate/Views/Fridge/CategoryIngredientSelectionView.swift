//
//  CategoryIngredientSelectionView.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//
// Quick-add ingredients by category, with search and selection

import SwiftUI

struct CategoryIngredientSelectionView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Predefined ingredients per category
    let ingredientMap: [IngredientCategory: [String]] = [
        .meat: [
            "Chicken breast", "Chicken thigh", "Ground beef", "Steak",
            "Pork loin", "Pork chop", "Bacon", "Turkey breast", "Lamb chop",
            "Salmon fillet", "Tuna (canned)", "Shrimp", "Cod", "Sausage",
            "Ham", "Duck breast", "Beef ribs", "Veal cutlet", "Bison steak"
        ],
        .vegetable: [
            "Tomato", "Onion", "Garlic", "Carrot", "Potato",
            "Broccoli", "Spinach", "Bell pepper", "Zucchini", "Eggplant",
            "Cucumber", "Mushroom", "Cauliflower", "Sweet potato", "Kale",
            "Celery", "Leek", "Asparagus", "Pea", "Corn"
        ],
        .fruit: [
            "Apple", "Banana", "Orange", "Strawberry", "Blueberry",
            "Raspberry", "Lemon", "Lime", "Mango", "Pineapple",
            "Peach", "Pear", "Grapes", "Watermelon", "Kiwi",
            "Cherry", "Apricot", "Blackberry", "Cranberry", "Grapefruit"
        ],
        .dairy: [
            "Milk", "Cream", "Butter", "Yogurt", "Sour cream",
            "Cottage cheese", "Mozzarella", "Cheddar cheese", "Parmesan",
            "Cream cheese", "Feta cheese", "Half and half", "Buttermilk",
            "Swiss cheese", "Blue cheese", "Gruyère", "Ricotta", "Goat cheese"
        ],
        .grain: [
            "Rice", "Brown rice", "Basmati rice", "Quinoa", "Oats",
            "Rolled oats", "Pasta", "Spaghetti", "Macaroni", "Bread",
            "Flour", "Cornmeal", "Couscous", "Barley", "Bulgur",
            "Tortilla", "Bagel", "Rye bread", "Pita bread"
        ],
        .spice: [
            "Salt", "Black pepper", "Paprika", "Cayenne pepper", "Cumin",
            "Turmeric", "Coriander", "Cinnamon", "Nutmeg", "Ginger",
            "Cloves", "Oregano", "Basil", "Thyme", "Rosemary",
            "Parsley", "Dill", "Chili powder", "Garlic powder", "Onion powder"
        ],
        .sauce: [
            "Soy sauce", "Tomato ketchup", "Mustard", "Mayonnaise", "BBQ sauce",
            "Hot sauce", "Worcestershire sauce", "Teriyaki sauce", "Hoisin sauce",
            "Fish sauce", "Olive oil", "Sesame oil", "Vinegar", "Balsamic vinegar",
            "Rice vinegar", "Chili paste", "Pesto", "Salsa", "Tahini", "Hot honey"
        ],
        .other: [
            "Egg", "Tofu", "Tempeh", "Honey", "Maple syrup",
            "Sugar", "Brown sugar", "Chocolate", "Peanut butter", "Jam",
            "Broth", "Chicken stock", "Beef stock", "Vegetable stock", "Yeast",
            "Gelatin", "Corn starch", "Baking powder", "Baking soda", "Vanilla extract"
        ]
    ]
    
    // Currently selected ingredient names
    @State private var selections: Set<String> = []
    // Text in the search bar
    @State private var searchText = ""
    
    // Initialize with existing fridge contents selected
    init(viewModel: FridgeViewModel) {
        self.viewModel = viewModel
        // Pre-select ingredients already in the fridge
        let existingNames = Set(viewModel.ingredients.map(\.name))
        _selections = State(initialValue: existingNames)
    }
    
    // Returns only those ingredients matching the search text
    private var filteredMap: [IngredientCategory: [String]] {
        let query = searchText.lowercased()
        return ingredientMap.mapValues { items in
            guard !query.isEmpty else { return items }
            return items.filter { $0.lowercased().contains(query) }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(IngredientCategory.allCases, id: \.self) { category in
                    CategorySection(
                        category: category,
                        items: filteredMap[category] ?? [],
                        selections: $selections
                    )
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Quick Add Ingredients")
            .toolbar {
                // Save button to sync selections with fridge
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // 1. Remove unselected ingredients
                        let toRemove = viewModel.ingredients
                            .filter { !selections.contains($0.name) }
                        toRemove.forEach { ingredient in
                            viewModel.removeIngredients(ingredient)
                        }

                        // 2. Add newly selected ingredients
                        let existing = Set(viewModel.ingredients.map(\.name))
                        let toAdd = selections.subtracting(existing)
                        let newItems = toAdd.map { name -> Ingredient in
                            let category = deriveCategory(from: name)
                            return Ingredient(
                                name: name,
                                category: category,
                                amount: 1,
                                unit: .piece
                            )
                        }
                        newItems.forEach(viewModel.addIngredient)

                        dismiss()
                    }
                }

                // Cancel button to dismiss without changes
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    // Determine the category for a given ingredient name
    private func deriveCategory(from name: String) -> IngredientCategory {
        IngredientCategory.allCases
            .first { ingredientMap[$0]?.contains(name) == true }
            ?? .other
    }

    fileprivate struct CategorySection: View {
        let category: IngredientCategory
        let items: [String]
        @Binding var selections: Set<String>

        var body: some View {
            Section(header: Text(category.rawValue)) {
                ForEach(items, id: \.self) { name in
                    Toggle(name, isOn: Binding(
                        get: { selections.contains(name) },
                        set: { isOn in
                            if isOn { selections.insert(name) }
                            else     { selections.remove(name) }
                        }
                    ))
                }
            }
        }
    }
}
