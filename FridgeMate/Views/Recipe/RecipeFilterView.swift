//
//  RecipeFilterView.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import SwiftUI

struct RecipeFilterView: View {
    @Binding var selectedCookingTime: CookingTimeFilter
    var onFilter: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Text("Cooking Time")
                .font(.subheadline)
                .fontWeight(.semibold)
            Menu {
                ForEach(CookingTimeFilter.allCases, id: \.self) { filter in
                    Button(action: {
                        selectedCookingTime = filter
                    }) {
                        HStack {
                            Text(filter.rawValue)
                            if selectedCookingTime == filter {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 2) {
                    Text(selectedCookingTime.rawValue)
                        .foregroundColor(Color.blue)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.blue)
                }
            }
//            .padding(.vertical, 2)
            Spacer(minLength: 0)
            Button(action: {
                onFilter()
            }) {
                Text("Filter")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

enum CookingTimeFilter: String, CaseIterable {
    case all = "All"
    case under15 = "Under 15 min"
    case under30 = "Under 30 min"
    case under60 = "Under 1 hour"
    case over60 = "Over 1 hour"
    
    var displayText: String {
        self.rawValue
    }
    
    func matches(_ cookingTime: Int) -> Bool {
        switch self {
        case .all:
            return true
        case .under15:
            return cookingTime <= 15
        case .under30:
            return cookingTime <= 30
        case .under60:
            return cookingTime <= 60
        case .over60:
            return cookingTime > 60
        }
    }
}

#Preview {
    RecipeFilterView(
        selectedCookingTime: .constant(.all),
        onFilter: {}
    )
} 
