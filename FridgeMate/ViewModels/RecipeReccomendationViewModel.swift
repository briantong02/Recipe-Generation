//
//  RecipeReccomendationViewModel.swift
//  FridgeMate
//
//  Created by Hai Tong on 4/5/25.
//

// RecipeRecommendationViewModel.swift
// Integrates Spoonacular API calls for recipe recommendations and details

import Foundation
import Combine

// MARK: - Models

/// A summary of a recipe returned by complex search.
struct RecipeSummary: Codable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let readyInMinutes: Int?
}

struct ComplexSearchResponse: Codable {
    let results: [RecipeSummary]
}

// MARK: - ViewModel

/// Fetches list of recipes based on ingredients.
class RecipeRecommendationViewModel: ObservableObject {
    @Published var recipes: [RecipeSummary] = []
    @Published var isLoadingList = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    /// Performs a complex search for recipes including given ingredients.
    func findRecipes(from ingredients: [Ingredient]) {
        guard !ingredients.isEmpty else {
            recipes = []
            return
        }
        isLoadingList = true
        errorMessage = nil

        let query = ingredients.map { $0.name }.joined(separator: ",")
        var components = URLComponents(string: "\(Constant().baseURL)/recipes/complexSearch")!
        components.queryItems = [
            URLQueryItem(name: "ingredients", value: query),
            URLQueryItem(name: "number", value: "10"),
            URLQueryItem(name: "apiKey", value: Constant().apiKey)
        ]

        guard let url = components.url else {
            errorMessage = "Invalid URL"
            isLoadingList = false
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ComplexSearchResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingList = false
                if case let .failure(err) = completion {
                    self?.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.recipes = response.results
            }
            .store(in: &cancellables)
    }
}

