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
                            expiryDate: hasExpiryDate ? expiryDate : nil
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
