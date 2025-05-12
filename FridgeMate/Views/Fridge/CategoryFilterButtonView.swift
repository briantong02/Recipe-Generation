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
    
    // Button style adjustment based on device size
    private var buttonStyle: (horizontalPadding: CGFloat, fontSize: CGFloat) {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth > 768 { // iPad
            return (horizontalPadding: 16, fontSize: 16)
        } else if screenWidth > 430 { // iPhone Pro Max
            return (horizontalPadding: 12, fontSize: 14)
        } else { // Regular iPhone
            return (horizontalPadding: 8, fontSize: 12)
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                Text(title)
                    .font(.system(size: buttonStyle.fontSize))
            }
            .padding(.horizontal, buttonStyle.horizontalPadding)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentColor : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}
