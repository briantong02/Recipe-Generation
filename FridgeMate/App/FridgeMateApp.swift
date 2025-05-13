//
//  FridgeMateApp.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import SwiftUI

@main
struct FridgeMateApp: App {
    @StateObject private var viewModel = FridgeViewModel()
    @StateObject private var recipeViewModel = RecipeRecommendationViewModel()
    @State private var selectedTab: Int = 0
    @State private var isShowingSplash = true

    var body: some Scene {
        WindowGroup {
            if isShowingSplash {
                // Splash screen
                SplashView(isActive: $isShowingSplash)
            } else {
                // Main TabView
                TabView(selection: $selectedTab) {
                    NavigationStack {
                        FridgeView(viewModel: viewModel)
                    }
                    .tabItem { Label("Fridge", systemImage: "refrigerator") }
                    .tag(0)

                    NavigationStack {
                        RecipeRecommendationView(fridgeVM: viewModel, vm: recipeViewModel)
                    }
                    .tabItem { Label("Recipe", systemImage: "book") }
                    .tag(1)

                    NavigationStack {
                        SavedRecipeView(
                            viewModel: recipeViewModel
                        )
                    }
                    .tabItem { Label("Saved", systemImage: "bookmark") }
                    .tag(2)
                }
                .onChange(of: selectedTab) { oldTab, newTab in
                    // When switching to Recipe tab (index 1), load recipes automatically
                    if newTab == 1 && !viewModel.ingredients.isEmpty {
                        // Load recipes with a slight delay to ensure view is fully loaded
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            recipeViewModel.loadRecipes(from: viewModel.ingredients)
                        }
                    }
                }
                .environmentObject(viewModel)
            }
        }
    }
}
