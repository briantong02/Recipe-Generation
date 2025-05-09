//
//  IngredientCardView.swift
//  FridgeMate
//
//  Created by Rujeet Prajapati on 06/05/2025.
//

import SwiftUI

struct IngredientCardView: View {
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
            } else {
                Text("No expiry date")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}
