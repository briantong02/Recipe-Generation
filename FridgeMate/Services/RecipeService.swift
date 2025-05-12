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
            URLQueryItem(name: "number", value: "10"),
            URLQueryItem(name: "apiKey", value: Constant.apiKey)
        ]
        print("🔗 Fetch URL:", components.url!)
        let request = URLRequest(url: components.url!)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                if let jsonString = String(data: output.data, encoding: .utf8) {
                    print("📥 Raw JSON Response:\n\(jsonString)")
                }
                
                if let response = try? JSONDecoder().decode(SpoonacularErrorResponse.self, from: output.data) {
                    throw SpoonacularAPIError.apiLimitReached(response.message)
                }
                
                return output.data
            }
            .decode(type: [APIRecipe].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Fetch detailed information for multiple recipes by their IDs
    func fetchBulkRecipeDetails(ids: [Int]) -> AnyPublisher<[APIRecipe], Error> {
        guard !ids.isEmpty else {
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        var components = URLComponents(
            url: baseURL.appendingPathComponent("recipes/informationBulk"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "ids", value: ids.map(String.init).joined(separator: ",")),
            URLQueryItem(name: "apiKey", value: Constant.apiKey)
        ]
        
        print("🔗 Bulk Fetch URL:", components.url!)
        let request = URLRequest(url: components.url!)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
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
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: APIRecipe.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct SpoonacularErrorResponse: Codable {
    let status: String
    let code: Int
    let message: String
}

enum SpoonacularAPIError: LocalizedError {
    case apiLimitReached(String)

    var errorDescription: String? {
        switch self {
        case .apiLimitReached(let message):
            return "API Error: \(message)"
        }
    }
}
