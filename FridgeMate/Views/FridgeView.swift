//
//  FridgeView.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import SwiftUI

struct FridgeView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @State private var showingQuickAddSheet = false
    @State private var showingManualAddSheet = false
    @State private var selectedCategory: IngredientCategory?
    
    
    var filteredIngredients: [Ingredient] {
        if let category = selectedCategory {
            return viewModel.ingredients.filter { $0.category == category }
        }
        return viewModel.ingredients
    }
    
    var body: some View {
        VStack {
            
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    Button("All") { selectedCategory = nil }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedCategory == nil ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(selectedCategory == nil ? .white : .primary)
                                        .cornerRadius(20)
                                    ForEach(IngredientCategory.allCases, id: \.self) { category in
                                        Button(category.rawValue) {
                                            selectedCategory = (selectedCategory == category ? nil : category)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(selectedCategory == category ? .white : .primary)
                                        .cornerRadius(20)
                                    }
                                }
                                .padding()
                            }
            
            // Ingredients List
            List {
                ForEach(filteredIngredients) { ingredient in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(ingredient.name)
                                .font(.headline)
                            Text("\(String(format: "%.1f", ingredient.amount)) \(ingredient.unit.rawValue)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        if let expiryDate = ingredient.expiryDate {
                            Text("Expires: \(expiryDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewModel.removeIngredient(filteredIngredients[index])
                    }
                }
            }
            .navigationTitle("My Fridge")
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                // Quick Add Button
                                Button("Quick Add") {
                                    showingQuickAddSheet = true
                                }
                                // Manual Add Sheet Button
                                Button {
                                    showingManualAddSheet = true
                                } label: {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                        // Quick Add sheet
                        .sheet(isPresented: $showingQuickAddSheet) {
                            CategoryIngredientSelectionView(viewModel: viewModel)
                        }
                        // Manual Add Sheet
                        .sheet(isPresented: $showingManualAddSheet) {
                            AddIngredientView(viewModel: viewModel)
                        }
                    }
                }
            }

