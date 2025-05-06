//
//  AddIngredientView.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import SwiftUI
import Foundation

struct AddIngredientView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var category = IngredientCategory.other
    @State private var amount = ""
    @State private var unit = Unit.gram
    @State private var expiryDate = Date()
    @State private var hasExpiryDate = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Ingredient Name", text: $name)
                
                Picker("Category", selection: $category) {
                    ForEach(IngredientCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                
                HStack {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Unit", selection: $unit) {
                        ForEach(Unit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                }
                
                Toggle("Has Expiry Date", isOn: $hasExpiryDate)
                
                if hasExpiryDate {
                    DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Ingredient")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    if let amountValue = Double(amount) {
                        let ingredient = Ingredient(
                            name: name,
                            category: category,
                            amount: amountValue,
                            unit: unit,
                            expiryDate: hasExpiryDate ? expiryDate : nil,
                            addedDate: Date()
                        )
                        viewModel.addIngredient(ingredient)
                        dismiss()
                    }
                }
                .disabled(name.isEmpty || amount.isEmpty)
            )
        }
    }
}

struct EditIngredientView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @Environment(\.dismiss) var dismiss
    
    let ingredient: Ingredient
    
    @State private var name: String
    @State private var category: IngredientCategory
    @State private var amount: String
    @State private var unit: Unit
    @State private var expiryDate: Date
    @State private var hasExpiryDate: Bool
    
    init(viewModel: FridgeViewModel, ingredient: Ingredient) {
        self.viewModel = viewModel
        self.ingredient = ingredient
        
        // Initialize state variables with existing ingredient values
        _name = State(initialValue: ingredient.name)
        _category = State(initialValue: ingredient.category)
        _amount = State(initialValue: String(ingredient.amount))
        _unit = State(initialValue: ingredient.unit)
        _expiryDate = State(initialValue: ingredient.expiryDate ?? Date())
        _hasExpiryDate = State(initialValue: ingredient.expiryDate != nil)
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Ingredient Name", text: .constant(name))
                    .disabled(true)
                    .foregroundColor(.gray)
                
                Picker("Category", selection: $category) {
                    ForEach(IngredientCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                
                HStack {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Unit", selection: $unit) {
                        ForEach(Unit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                }
                
                Toggle("Has Expiry Date", isOn: $hasExpiryDate)
                
                if hasExpiryDate {
                    DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Edit Ingredient")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    if let amountValue = Double(amount) {
                        let updatedIngredient = Ingredient(
                            id: ingredient.id,
                            name: name,
                            category: category,
                            amount: amountValue,
                            unit: unit,
                            expiryDate: hasExpiryDate ? expiryDate : nil,
                            addedDate: ingredient.addedDate
                        )
                        // Remove old ingredient and add updated one
                        viewModel.removeIngredients(ingredient)
                        viewModel.addIngredient(updatedIngredient)
                        dismiss()
                    }
                }
                .disabled(name.isEmpty || amount.isEmpty)
            )
        }
    }
}
