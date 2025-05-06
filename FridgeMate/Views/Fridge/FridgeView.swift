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
        
        return result
    }
    
    var groupedIngredients: [IngredientCategory: [Ingredient]] {
        Dictionary(grouping: filteredIngredients) { $0.category }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText, placeholder: "Search ingredients...")
                    .padding()
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryFilterButton(
                            title: "All",
                            isSelected: selectedCategory == nil,
                            systemImage: "square.grid.2x2",
                            action: { selectedCategory = nil }
                        )
                        
                        ForEach(IngredientCategory.allCases, id: \.self) { category in
                            CategoryFilterButton(
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
                                                IngredientCard(ingredient: ingredient)
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
        }
    }
}

// MARK: - Supporting Views
struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                Text(title)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentColor : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

struct CategoryHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

struct IngredientCard: View {
    let ingredient: Ingredient
    
    var expiryStatus: ExpiryStatus {
        guard let expiryDate = ingredient.expiryDate else { return .none }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: expiryDate).day ?? 0
        if days < 0 { return .expired }
        if days <= 3 { return .soon }
        return .good
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title and Amount
            VStack(alignment: .leading, spacing: 4) {
                Text(ingredient.name.capitalized)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("\(String(format: "%.1f", ingredient.amount)) \(ingredient.unit.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Expiry Date
            if let expiryDate = ingredient.expiryDate {
                HStack {
                    Image(systemName: expiryStatus.iconName)
                    Text(expiryStatus.message(for: expiryDate))
                }
                .font(.caption)
                .foregroundColor(expiryStatus.color)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct EmptyFridgeView: View {
    @Binding var showingManualAddSheet: Bool
    @Binding var showingQuickAddSheet: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "refrigerator")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Your fridge is empty")
                .font(.title2)
                .foregroundColor(.primary)
            
            Text("Start adding ingredients to your fridge")
                .font(.body)
                .foregroundColor(.gray)
            
            HStack(spacing: 12) {
                Button {
                    showingQuickAddSheet = true
                } label: {
                    HStack {
                        Image(systemName: "bolt.fill")
                        Text("Quick Add")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
                }
                
                Button {
                    showingManualAddSheet = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Ingredient")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Helper Types
enum ExpiryStatus {
    case none
    case good
    case soon
    case expired
    
    var color: Color {
        switch self {
        case .none: return .gray
        case .good: return .green
        case .soon: return .orange
        case .expired: return .red
        }
    }
    
    var iconName: String {
        switch self {
        case .none: return "calendar"
        case .good: return "checkmark.circle"
        case .soon: return "exclamationmark.circle"
        case .expired: return "xmark.circle"
        }
    }
    
    func message(for date: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
        switch self {
        case .expired: return "Expired"
        case .soon: return "Expires in \(days) days"
        case .good: return "Expires in \(days) days"
        case .none: return ""
        }
    }
}

extension IngredientCategory {
    var systemImage: String {
        switch self {
        case .vegetable: return "leaf"
        case .fruit: return "tree"
        case .meat: return "fork.knife"
        case .dairy: return "cup.and.saucer"
        case .grain: return "apple.meditate"
        case .spice: return "sparkles"
        case .sauce: return "drop"
        case .other: return "square.grid.2x2"
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    FridgeView(viewModel: FridgeViewModel())
}

#Preview {
    SearchBar(text: .constant(""), placeholder: "Search...")
        .padding()
}

