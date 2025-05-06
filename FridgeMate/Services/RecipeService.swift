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
//    private let apiKey = "ccfd8971c58b4f84be3616e3c3ca0d17"
    private let baseURL = URL(string: Constant.baseURL)!

    // Fetch recipes with detailed info based on ingredients
    func fetchRecipes(query ingredients: [String]) -> AnyPublisher<[APIRecipe], Error> {
        guard !ingredients.isEmpty else {
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        var components = URLComponents(
            url: baseURL.appendingPathComponent("recipes/findByIngredients"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "ingredients", value: ingredients.joined(separator: ",")),
            URLQueryItem(name: "addRecipeInformation", value: "true"),
            URLQueryItem(name: "number", value: "30"),
            URLQueryItem(name: "apiKey", value: Constant.apiKey)
        ]
        print("🔗 Fetch URL:", components.url!)
        let request = URLRequest(url: components.url!)
        let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Perform the network request and decode into [APIRecipe]
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [APIRecipe].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Fetch detailed recipe information by API ID
    func fetchRecipeDetail(id: Int) -> AnyPublisher<APIRecipe, Error> {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("recipes/\(id)/information"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "includeNutrition", value: "true"),
            URLQueryItem(name: "apiKey", value: Constant.apiKey)
        ]
        let request = URLRequest(url: components.url!)
        
        let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Perform the network request and decode into a single APIRecipe
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: APIRecipe.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
