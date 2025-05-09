//
//  ExpiryStatus.swift
//  FridgeMate
//
//  Created by Rujeet Prajapati on 06/05/2025.
//

import SwiftUI

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
