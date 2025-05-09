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
    @State private var searchText = ""
    @State private var selectedIngredient: Ingredient?
    @State private var showSortSheet = false
    @State private var selectedSort: SortOption? = nil
    @State private var sortOrder: SortOrder = .ascending
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var filteredIngredients: [Ingredient] {
        var result = viewModel.ingredients
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        if let selectedSort = selectedSort {
            switch selectedSort {
            case .expiration:
                result.sort { sortOrder == .ascending ?
                    ($0.expiryDate ?? .distantFuture) < ($1.expiryDate ?? .distantFuture) :
                    ($0.expiryDate ?? .distantFuture) > ($1.expiryDate ?? .distantFuture) }
            case .addedDate:
                result.sort { sortOrder == .ascending ?
                    $0.addedDate < $1.addedDate :
                    $0.addedDate > $1.addedDate }
            case .quantity:
                result.sort { sortOrder == .ascending ?
                    $0.amount < $1.amount :
                    $0.amount > $1.amount }
            }
        }
        
        return result
    }
    
    var groupedIngredients: [IngredientCategory: [Ingredient]] {
        Dictionary(grouping: filteredIngredients) { $0.category }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBarView(text: $searchText, placeholder: "Search ingredients...")
                    .padding()
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryFilterButtonView(
                            title: "All",
                            isSelected: selectedCategory == nil,
                            systemImage: "square.grid.2x2",
                            action: { selectedCategory = nil }
                        )
                        
                        ForEach(IngredientCategory.allCases, id: \.self) { category in
                            CategoryFilterButtonView(
                                title: category.rawValue,
                                isSelected: selectedCategory == category,
                                systemImage: category.systemImage,
                                action: { selectedCategory = (selectedCategory == category ? nil : category) }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
                HStack {
                    Text(selectedCategory?.rawValue ?? "All")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: { showSortSheet = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.arrow.down")
                            Text("Sort by")
                        }
                        .font(.subheadline)
                    }
                    .padding(.trailing)
                    .actionSheet(isPresented: $showSortSheet) {
                        ActionSheet(
                            title: Text("Sort by"),
                            message: nil,
                            buttons: [
                                .default(Text("Expiration")) { selectedSort = .expiration },
                                .default(Text("Added Date")) { selectedSort = .addedDate },
                                .default(Text("Quantity")) { selectedSort = .quantity },
                                .default(Text(sortOrder == .ascending ? "Descending" : "Ascending")) {
                                    sortOrder = (sortOrder == .ascending ? .descending : .ascending)
                                },
                                .cancel()
                            ]
                        )
                    }
                }
                .padding(.horizontal)
                
                if filteredIngredients.isEmpty {
                    EmptyFridgeView(showingManualAddSheet: $showingManualAddSheet, showingQuickAddSheet: $showingQuickAddSheet)
                } else {
                    // Ingredients List
                    ScrollView {
                        LazyVStack(spacing: 16, pinnedViews: .sectionHeaders) {
                            ForEach(IngredientCategory.allCases, id: \.self) { category in
                                if let ingredients = groupedIngredients[category], !ingredients.isEmpty {
                                    Section(header: CategoryHeader(title: category.rawValue)) {
                                        LazyVGrid(columns: columns, spacing: 16) {
                                            ForEach(ingredients) { ingredient in
                                                IngredientCardView(ingredient: ingredient)
                                                    .onTapGesture {
                                                        selectedIngredient = ingredient
                                                    }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("My Fridge")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Quick Add") {
                        showingQuickAddSheet = true
                    }
                    Button {
                        showingManualAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingQuickAddSheet) {
                CategoryIngredientSelectionView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingManualAddSheet) {
                AddIngredientView(viewModel: viewModel)
            }
            .sheet(item: $selectedIngredient) { ingredient in
                EditIngredientView(viewModel: viewModel, ingredient: ingredient)
            }
        }
    }
}

#Preview {
    FridgeView(viewModel: FridgeViewModel())
}

