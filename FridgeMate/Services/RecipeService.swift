//
//  RecipeService.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 5/5/2025.
//

import Foundation
import Combine

// Centralised service for Sponacular API interaction
class RecipeService {
    static let shared = RecipeService()
    private let apiKey = "ccfd8971c58b4f84be3616e3c3ca0d17"
    private let baseURL = URL(string: "https://api.spoonacular.com")!

    // Fetch recipes with detailed info based on ingredients
    func fetchRecipes(query ingredients: [String]) -> AnyPublisher<[APIRecipe], Error> {
        guard !ingredients.isEmpty else {
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        var components = URLComponents(url: baseURL.appendingPathComponent("recipes/complexSearch"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "includeIngredients", value: ingredients.joined(separator: ",")),
            URLQueryItem(name: "addRecipeInformation", value: "true"),
            URLQueryItem(name: "number", value: "10"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        let request = URLRequest(url: components.url!)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: SpoonacularRecipeResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Fetch detailed recipe information by API ID
    func fetchRecipeDetail(id: Int) -> AnyPublisher<APIRecipe, Error> {
        var components = URLComponents(url: baseURL.appendingPathComponent("recipes/\(id)/information"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "includeNutrition", value: "true"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        let request = URLRequest(url: components.url!)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: APIRecipe.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
