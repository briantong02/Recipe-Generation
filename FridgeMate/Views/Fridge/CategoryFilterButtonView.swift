//
//  CategoryFilterButtonView.swift
//  FridgeMate
//
//  Created by Rujeet Prajapati on 06/05/2025.
//

import SwiftUI

struct CategoryFilterButtonView: View {
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
