//
//  UserPreferencesView.swift
//  FridgeMate
//
//  Created by Chaeyeon Yu on 29/4/2025.
//

import SwiftUI

struct UserPreferencesView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @Binding var selectedTab: Int
    
    // MARK: - State for UI Bindings
    @State private var selectedNationality: Nationality = .other
    @State private var selectedPreferences: Set<FoodPreference> = []
    @State private var selectedAllergies: Set<Allergy> = []
    @State private var selectedTabIndex = 0
    @State private var selectedSkillLevel: CookingSkillLevel = .beginner
    @State private var selectedCookingTools: Set<CookingTool> = []
    @State private var selectedPrepTime: PrepTime = .quick
    @State private var showSaveSuccess = false
    @State private var isLoaded = false
    
    var body: some View {
        Group {
            if isLoaded {
                VStack {
                    Picker("", selection: $selectedTabIndex) {
                        Text("Food").tag(0)
                        Text("Allergy").tag(1)
                        Text("Setup").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    TabView(selection: $selectedTabIndex) {
                        // MARK: - Food Preferences
                        Form {
                            ForEach(FoodPreference.allCases, id: \.self) { preference in
                                Toggle(preference.rawValue, isOn: Binding(
                                    get: { selectedPreferences.contains(preference) },
                                    set: { isSelected in
                                        if isSelected {
                                            selectedPreferences.insert(preference)
                                        } else {
                                            selectedPreferences.remove(preference)
                                        }
                                    }
                                ))
                            }
                        }
                        .tag(0)
                        
                        // MARK: - Allergies
                        Form {
                            ForEach(Allergy.allCases, id: \.self) { allergy in
                                Toggle(allergy.rawValue, isOn: Binding(
                                    get: { selectedAllergies.contains(allergy) },
                                    set: { isSelected in
                                        if isSelected {
                                            selectedAllergies.insert(allergy)
                                        } else {
                                            selectedAllergies.remove(allergy)
                                        }
                                    }
                                ))
                            }
                        }
                        .tag(1)
                        
                        // MARK: - Setup
                        Form {
                            Section(header: Text("Nationality")) {
                                Picker("Select your nationality", selection: $selectedNationality) {
                                    ForEach(Nationality.allCases, id: \.self) { nation in
                                        Text(nation.rawValue).tag(nation)
                                    }
                                }
                            }
                            
                            Section(header: Text("Cooking Skill Level")) {
                                Picker("Select your cooking skill level", selection: $selectedSkillLevel) {
                                    ForEach(CookingSkillLevel.allCases, id: \.self) { level in
                                        Text(level.rawValue).tag(level)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            Section(header: Text("Available Cooking Tools")) {
                                ForEach(CookingTool.allCases, id: \.self) { tool in
                                    Toggle(tool.rawValue, isOn: Binding(
                                        get: { selectedCookingTools.contains(tool) },
                                        set: { isSelected in
                                            if isSelected {
                                                selectedCookingTools.insert(tool)
                                            } else {
                                                selectedCookingTools.remove(tool)
                                            }
                                        }
                                    ))
                                }
                            }
                            
                            Section(header: Text("Maximum Preparation Time")) {
                                Picker("Select maximum preparation time", selection: $selectedPrepTime) {
                                    ForEach(PrepTime.allCases, id: \.self) { time in
                                        Text(time.rawValue)
                                            .multilineTextAlignment(.center)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(height: 30)
                            }
                        }
                        .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    // MARK: - Save Button
                    VStack {
                        if showSaveSuccess {
                            Text("Preferences saved successfully!")
                                .foregroundColor(.green)
                                .padding(.top, 20)
                        }
                        
                        Button("Save Preferences") {
                            let preferences = UserPreferences(
                                nationality: selectedNationality,
                                preferences: Array(selectedPreferences),
                                allergies: Array(selectedAllergies),
                                cookingSkillLevel: selectedSkillLevel,
                                cookingTools: selectedCookingTools,
                                maxPrepTime: selectedPrepTime
                            )
                            viewModel.updateUserPreferences(preferences)
                            showSaveSuccess = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showSaveSuccess = false
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding()
                    }
                    .cornerRadius(20)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                    .background(Color.clear)
                }
            } else {
                // MARK: - Loading View
                ProgressView("Loading preferences...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            let saved = viewModel.userPreferences
            selectedNationality = saved.nationality ?? .other
            selectedPreferences = Set(saved.preferences)
            selectedAllergies = Set(saved.allergies)
            selectedSkillLevel = saved.cookingSkillLevel
            selectedCookingTools = saved.cookingTools
            selectedPrepTime = saved.maxPrepTime
            isLoaded = true
        }
        .navigationTitle("User Preferences")
    }
}

struct UserPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        UserPreferencesView(
            viewModel: FridgeViewModel(),
            selectedTab: .constant(2)
        )
    }
}
