//
//  SortOption.swift
//  FridgeMate
//
//  Created by Rujeet Prajapati on 06/05/2025.
//

enum SortOption: String, CaseIterable, Identifiable {
    case expiration = "Expiration"
    case addedDate = "Added Date"
    case quantity = "Quantity"
    var id: String { self.rawValue }
}


