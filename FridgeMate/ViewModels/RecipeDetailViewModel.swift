//
//  RecipeDetailViewModel.swift
//  FridgeMate
//
//  Created by Hai Tong on 4/5/25.
//

import Foundation
import Combine

// ViewModel for detailed recipe view
class RecipeDetailViewModel: ObservableObject {
    @Published var detail: APIRecipe?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    // Fetch full recipe detail by API ID
    func loadDetail(id: Int) {
        isLoading = true
        errorMessage = nil

        RecipeService.shared
            .fetchRecipeDetail(id: id)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case let .failure(err) = completion {
                        self?.errorMessage = err.localizedDescription
                    }
                },
                receiveValue: { [weak self] apiRecipe in
                    self?.detail = apiRecipe
                }
            )
            .store(in: &cancellables)
    }
}
