//
//  CategoryIngredientSelectionView.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import SwiftUI

struct CategoryIngredientSelectionView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @Environment(\.dismiss) private var dismiss
    
    let ingredientMap: [IngredientCategory: [String]] = [
      .meat: ["Chicken breast","Beef mince","Pork belly","Lamb","Tuna (canned)"],
      .vegetable: ["Spinach","Onion","Tomato","Potato"],
      .fruit: ["Apple","Banana","Orange","Strawberry", "Watermelon"],
      .grain: ["Rice","Pasta","Bread","Flour"],
      .dairy: ["Milk","Cheese","Yogurt"],
      .spice: ["Salt","Pepper","Chili powder"],
      .sauce: ["Soy sauce","Oyster sauce","Ketchup","Mayonnaise"],
      .other: ["Egg","Tofu","Mushroom"]
    ]
    
    @State private var selections: Set<String> = []
    @State private var searchText = ""
    
    private var lowercasedQuery: String {
           searchText.lowercased()
       }

       var filteredMap: [IngredientCategory: [String]] {
           var result: [IngredientCategory:[String]] = [:]
           for (category, items) in ingredientMap {
               if lowercasedQuery.isEmpty {
                   result[category] = items
               } else {
                   result[category] = items.filter { $0.lowercased().contains(lowercasedQuery) }
               }
           }
           return result
       }

       var body: some View {
           NavigationView {
               List {
                   ForEach(IngredientCategory.allCases, id: \.self) { category in
                       Section(header: Text(category.rawValue)) {
                           let names = filteredMap[category] ?? []
                           ForEach(names, id:\.self) { name in
                               Toggle(name, isOn: Binding(
                                   get: { selections.contains(name) },
                                   set: { isOn in
                                       if isOn { selections.insert(name) }
                                       else    { selections.remove(name) }
                                   }
                               ))
                           }
                       }
                   }
               }
               .listStyle(.insetGrouped)
               .searchable(text: $searchText,
                           placement: .navigationBarDrawer(displayMode: .always))
               .navigationTitle("Quick Add Ingredients")
               .toolbar {
                   ToolbarItem(placement: .confirmationAction) {
                       Button("Add \(selections.count)") {
                           let newItems = selections.map {
                               Ingredient(name: $0,
                                          category: deriveCategory(from: $0),
                                          amount: 1,
                                          unit: .piece)
                           }
                           viewModel.addIngredients(newItems)
                           dismiss()
                       }
                       .disabled(selections.isEmpty)
                   }
               }
           }
       }

       func deriveCategory(from name: String) -> IngredientCategory {
           IngredientCategory.allCases.first {
               ingredientMap[$0]?.contains(name) == true
           } ?? .other
       }
   }
