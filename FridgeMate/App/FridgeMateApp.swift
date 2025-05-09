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
                    NavigationView {
                        FridgeView(viewModel: viewModel)
                    }
                    .tabItem { Label("Fridge", systemImage: "refrigerator") }
                    .tag(0)

                    NavigationView {
                        RecipeRecommendationView(fridgeVM: viewModel, vm: recipeViewModel)
                    }
                    .tabItem { Label("Recipes", systemImage: "book") }
                    .tag(1)

                    NavigationView {
//                        UserPreferencesView(viewModel: viewModel, selectedTab: $selectedTab)
                        SavedRecipeView(
                            viewModel: recipeViewModel
                        )
                    }
                    .tabItem { Label("Saved", systemImage: "bookmark") }
                    .tag(2)
                }
                .environmentObject(viewModel)
            }
        }
    }
}
