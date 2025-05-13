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
    
    // Shared URLSession with custom configuration
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60.0
        config.timeoutIntervalForResource = 60.0
        config.waitsForConnectivity = true
        config.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: config)
    }()

    // Fetch basic recipe info by ingredients
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
        
        print("🔗 Fetching recipes for:", ingredients.joined(separator: ", "))
        
        var request = URLRequest(url: components.url!)
        request.cachePolicy = .useProtocolCachePolicy
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return session.dataTaskPublisher(for: request)
            .tryMap { output in
                // Print response for debugging
                print("📥 Response status code: \(String(describing: (output.response as? HTTPURLResponse)?.statusCode))")
                
                if let response = try? JSONDecoder().decode(SpoonacularErrorResponse.self, from: output.data) {
                    throw SpoonacularAPIError.apiLimitReached(response.message)
                }
                return output.data
            }
            .decode(type: [APIRecipe].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Fetch detailed recipe info for multiple recipes
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
        
        print("🔗 Fetching details for recipe IDs:", ids)
        
        var request = URLRequest(url: components.url!)
        request.cachePolicy = .useProtocolCachePolicy
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return session.dataTaskPublisher(for: request)
            .tryMap { output in
                // Print response for debugging
                print("📥 Bulk response status code: \(String(describing: (output.response as? HTTPURLResponse)?.statusCode))")
                
                if let response = try? JSONDecoder().decode(SpoonacularErrorResponse.self, from: output.data) {
                    throw SpoonacularAPIError.apiLimitReached(response.message)
                }
                return output.data
            }
            .decode(type: [APIRecipe].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Fetch single recipe detail
    func fetchRecipeDetail(id: Int) -> AnyPublisher<APIRecipe, Error> {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("recipes/\(id)/information"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "includeNutrition", value: "true"),
            URLQueryItem(name: "apiKey", value: Constant.apiKey)
        ]
        
        var request = URLRequest(url: components.url!)
        request.cachePolicy = .useProtocolCachePolicy
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return session.dataTaskPublisher(for: request)
            .tryMap { output in
                if let response = try? JSONDecoder().decode(SpoonacularErrorResponse.self, from: output.data) {
                    throw SpoonacularAPIError.apiLimitReached(response.message)
                }
                return output.data
            }
            .decode(type: APIRecipe.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Add a special debug method to test API connectivity on iPad
    func testAPIConnectivity(completion: @escaping (Bool) -> Void) {
        // Test endpoint with minimal data transfer
        var components = URLComponents(
            url: baseURL.appendingPathComponent("recipes/random"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "number", value: "1"),
            URLQueryItem(name: "apiKey", value: Constant.apiKey)
        ]
        
        print("🧪 Testing API connectivity...")
        var request = URLRequest(url: components.url!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("🧪 API test failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("�� API test response: \(response.statusCode)")
                let isSuccess = response.statusCode >= 200 && response.statusCode < 300
                DispatchQueue.main.async {
                    completion(isSuccess)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
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
