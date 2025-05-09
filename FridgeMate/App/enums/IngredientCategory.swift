//
//  IngredientCategory.swift
//  FridgeMate
//
//  Created by Rujeet Prajapati on 06/05/2025.
//

import Foundation
import SwiftUI

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
