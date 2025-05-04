//
//  UserPreferences.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import Foundation

struct UserPreferences: Codable {
    var nationality: Nationality?
    var preferences: [FoodPreference]
    var allergies: [Allergy]
    var cookingSkillLevel: CookingSkillLevel
    var cookingTools: Set<CookingTool>
    var maxPrepTime: PrepTime
}

enum Nationality: String, Codable, CaseIterable {
    case american = "American"
    case australian = "Australian"
    case british = "British"
    case canadian = "Canadian"
    case chinese = "Chinese"
    case egyptian = "Egyptian"
    case filipino = "Filipino"
    case french = "French"
    case german = "German"
    case greek = "Greek"
    case indian = "Indian"
    case indonesian = "Indonesian"
    case irish = "Irish"
    case italian = "Italian"
    case japanese = "Japanese"
    case korean = "Korean"
    case lebanese = "Lebanese"
    case malaysian = "Malaysian"
    case nepalese = "Nepalese"
    case newZealander = "New Zealander"
    case other = "Other"
    case pacificIslander = "Pacific Islander"
    case southAfrican = "South African"
    case thai = "Thai"
    case turkish = "Turkish"
    case vietnamese = "Vietnamese"
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

enum CookingSkillLevel: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case expert = "Expert"
}

enum CookingTool: String, Codable, CaseIterable {
    case oven = "Oven"
    case microwave = "Microwave"
    case airFryer = "Air fryer"
    case stove = "Stove"
    case noCook = "No-cook"
}

enum PrepTime: String, Codable, CaseIterable {
    case quick = "Less than\n 15 min"
    case medium = "15-30 min"
    case long = "30-60 min"
}
