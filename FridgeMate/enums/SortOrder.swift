//
//  SortOrder.swift
//  FridgeMate
//
//  Created by Rujeet Prajapati on 06/05/2025.
//

enum SortOrder: String, CaseIterable, Identifiable {
    case ascending = "Ascending"
    case descending = "Descending"
    var id: String { self.rawValue }
}
