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

// MARK: - API Models (Internal to ViewModel)

struct APIRecipe: Identifiable, Decodable {
    let id: Int
    let title: String
    let image: String
}

struct APIDetailedRecipe: Decodable {
    let id: Int
    let title: String
    let image: String
    let summary: String
    let readyInMinutes: Int
    let servings: Int
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let cheap: Bool
    let sustainable: Bool
    let dishTypes: [String]
    let cuisines: [String]
    let extendedIngredients: [IngredientDetail]
    let analyzedInstructions: [InstructionBlock]
    let nutrition: NutritionInfo
}

struct IngredientDetail: Identifiable, Decodable {
    let id: Int
    let aisle: String
    let name: String
    let original: String
    let amount: Double
    let unit: String
    let measures: MeasureOptions
}

struct MeasureOptions: Decodable {
    let us: Measure
    let metric: Measure
}

struct Measure: Decodable {
    let amount: Double
    let unitShort: String
    let unitLong: String
}

struct InstructionBlock: Decodable {
    let name: String
    let steps: [Step]
}

struct Step: Identifiable, Decodable {
    let id = UUID()
    let number: Int
    let step: String
    let ingredients: [SimpleIngredient]
    let equipment: [SimpleEquipment]
}

struct SimpleIngredient: Identifiable, Decodable {
    let id: Int
    let name: String
}

struct SimpleEquipment: Identifiable, Decodable {
    let id: Int
    let name: String
}

struct NutritionInfo: Decodable {
    let nutrients: [Nutrient]
}

struct Nutrient: Identifiable, Decodable {
    var id: String { name }
    let name: String
    let amount: Double
    let unit: String
    let percentOfDailyNeeds: Double
}

// MARK: - ViewModel

class RecipeRecommendationViewModel: ObservableObject {
    @Published var recommendedRecipes: [APIRecipe] = []
    @Published var selectedRecipeDetail: APIDetailedRecipe?
    @Published var isLoadingRecipes = false
    @Published var isLoadingDetail = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let apiKey = "YOUR_SPOONACULAR_API_KEY"

    /// Fetches recipes matching the given ingredient names
    func findRecipes(from ingredients: [Ingredient]) {
        guard !ingredients.isEmpty else {
            errorMessage = "No ingredients available to search recipes."
            return
        }
        isLoadingRecipes = true
        errorMessage = nil

        let list = ingredients.map { $0.name }.joined(separator: ",")
        var comps = URLComponents(string: "https://api.spoonacular.com/recipes/findByIngredients")!
        comps.queryItems = [
            URLQueryItem(name: "ingredients", value: list),
            URLQueryItem(name: "number", value: "10"),
            URLQueryItem(name: "apiKey", value: Constant().apiKey)
        ]

        URLSession.shared.dataTaskPublisher(for: comps.url!)
            .map(\.data)
            .decode(type: [APIRecipe].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingRecipes = false
                if case let .failure(err) = completion {
                    self?.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] recipes in
                self?.recommendedRecipes = recipes
            }
            .store(in: &cancellables)
    }

    /// Fetches detailed information for a specific recipe ID
    func fetchDetail(for recipeID: Int) {
        isLoadingDetail = true
        errorMessage = nil

        guard let url = URL(string: "\(Constant().baseURL)/recipes/\(recipeID)/information?includeNutrition=true&apiKey=\(apiKey)") else {
            errorMessage = "Invalid URL for recipe detail."
            isLoadingDetail = false
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: APIDetailedRecipe.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingDetail = false
                if case let .failure(err) = completion {
                    self?.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] detail in
                self?.selectedRecipeDetail = detail
            }
            .store(in: &cancellables)
    }
}
