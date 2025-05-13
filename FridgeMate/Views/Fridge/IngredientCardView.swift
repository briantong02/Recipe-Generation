//
//  IngredientCardView.swift
//  FridgeMate
//
//  Created by Rujeet Prajapati on 06/05/2025.
//

import SwiftUI

struct IngredientCardView: View {
    let ingredient: Ingredient
    
    // Font size adjustment based on device size
    private var textStyle: (titleSize: CGFloat, subtitleSize: CGFloat, captionSize: CGFloat) {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth > 768 { // iPad
            return (titleSize: 20, subtitleSize: 16, captionSize: 14)
        } else if screenWidth > 430 { // iPhone Pro Max
            return (titleSize: 17, subtitleSize: 14, captionSize: 12)
        } else { // Regular iPhone
            return (titleSize: 15, subtitleSize: 12, captionSize: 10)
        }
    }
    
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
                    .font(.system(size: textStyle.titleSize, weight: .semibold))
                    .lineLimit(1)
                
                Text("\(String(format: "%.1f", ingredient.amount)) \(ingredient.unit.rawValue)")
                    .font(.system(size: textStyle.subtitleSize))
                    .foregroundColor(.gray)
            }
            
            // Expiry Date
            if let expiryDate = ingredient.expiryDate {
                HStack {
                    Image(systemName: expiryStatus.iconName)
                    Text(expiryStatus.message(for: expiryDate))
                }
                .font(.system(size: textStyle.captionSize))
                .foregroundColor(expiryStatus.color)
            } else {
                Text("No expiry date")
                    .font(.system(size: textStyle.captionSize))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}
