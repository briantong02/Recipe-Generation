//
//  RecipeDetailViewModel.swift
//  FridgeMate
//
//  Created by Hai Tong on 4/5/25.
//

import Foundation
import Combine

// MARK: - Models

/// Detailed recipe information returned by the information endpoint.
struct DetailedRecipe: Codable {
    let id: Int
    let title: String
    let image: String
    let summary: String?
    let instructions: String?
    let extendedIngredients: [IngredientDetail]?
    let nutrition: NutritionData?
}

struct IngredientDetail: Codable, Identifiable {
    let id: Int
    let original: String
}

struct NutritionData: Codable {
    let nutrients: [Nutrient]
}

struct Nutrient: Codable, Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let unit: String
}

// MARK: - ViewModel

/// Fetches detailed recipe data for a given recipe ID.
class RecipeDetailModel: ObservableObject {
    @Published var detail: DetailedRecipe?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    /// Fetches full recipe information including nutrition.
    func fetchDetail(for id: Int) {
        isLoading = true
        errorMessage = nil

        let urlString = "\(Constant().baseURL)/recipes/\(id)/information?includeNutrition=true&apiKey=\(Constant().apiKey)"
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: DetailedRecipe.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(err) = completion {
                    self?.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] recipe in
                self?.detail = recipe
            }
            .store(in: &cancellables)
    }
}

