//
//  UserPreferences.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import Foundation

struct UserPreferences: Codable {
    var nationality: Nationality
    var preferences: [FoodPreference]
    var allergies: [Allergy]
}

enum Nationality: String, Codable, CaseIterable {
    // Asian countries
    case korean          = "Korean"
    case chinese         = "Chinese"
    case japanese        = "Japanese"
    case vietnamese      = "Vietnamese"
    case filipino        = "Filipino"
    case indian          = "Indian"
    case thai            = "Thai"
    case indonesian      = "Indonesian"
    case malaysian       = "Malaysian"
    
    // European countries
    case british         = "British"
    case irish           = "Irish"
    case italian         = "Italian"
    case greek           = "Greek"
    case german          = "German"
    case french          = "French"

    // Middle Eastern and African countries
    case lebanese        = "Lebanese"
    case turkish         = "Turkish"
    case egyptian        = "Egyptian"
    case southAfrican    = "South African"

    // Oceania and Americas
    case australian      = "Australian"
    case newZealander    = "New Zealander"
    case american        = "American"
    case canadian        = "Canadian"

    // Others
    case pacificIslander = "Pacific Islander"
    case indigenousAustralian = "Indigenous Australian"
    case other           = "Other"
}

enum FoodPreference: String, Codable, CaseIterable {
    // By Cuisine (Popular worldwide)
    case australian       = "Australian"
    case british          = "British"
    case italian          = "Italian"
    case greek            = "Greek"
    case mexican          = "Mexican"
    case indian           = "Indian"
    case chinese          = "Chinese"
    case japanese         = "Japanese"
    case korean           = "Korean"
    case vietnamese       = "Vietnamese"
    case thai             = "Thai"
    case middleEastern    = "Middle Eastern"
    
    // By Food Style
    case barbecue         = "BBQ"
    case seafood          = "Seafood"
    case bakery           = "Bakery"
    case dessert          = "Dessert"
    case healthy          = "Healthy"
    
    // By Dietary Lifestyle
    case vegetarian       = "Vegetarian"
    case vegan            = "Vegan"
    case glutenFree       = "Gluten-Free"
    case dairyFree        = "Dairy-Free"
    case halal            = "Halal"
    case kosher           = "Kosher"
    case lowCarb          = "Low-Carb"
}

enum Allergy: String, Codable, CaseIterable {
    // Major allergens according to FSANZ (Food Standards Australia New Zealand)
    case gluten                 = "Gluten"
    case crustacea              = "Crustacea"
    case eggs                   = "Eggs"
    case fish                   = "Fish"
    case peanuts                = "Peanuts"
    case soybeans               = "Soybeans"
    case milk                   = "Milk"
    case treeNuts               = "Tree Nuts"
    case sesameSeeds            = "Sesame Seeds"
    case mustard                = "Mustard"
    case sulphites              = "Sulphites"
    
    // Other common allergens
    case lupin                  = "Lupin"
    case celery                 = "Celery"
    case dairy                  = "Dairy"
    case shellfish              = "Shellfish"
    case fishSpecific           = "Fish (specific)"
    case soy                    = "Soy"
}
