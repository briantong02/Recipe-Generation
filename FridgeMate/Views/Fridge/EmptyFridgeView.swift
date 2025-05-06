//
//  EmptyFridgeView.swift
//  FridgeMate
//
//  Created by Rujeet Prajapati on 06/05/2025.
//

import SwiftUI

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
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
                }
                
                Button {
                    showingManualAddSheet = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add\nIngredient")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 40)
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
