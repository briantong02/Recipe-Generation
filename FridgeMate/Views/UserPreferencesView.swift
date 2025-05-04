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
    // @State private var selectedNationality: Nationality = .australian
    @State private var selectedPreferences: Set<FoodPreference> = []
    @State private var selectedAllergies: Set<Allergy> = []
    @State private var selectedTabIndex = 0
    @State private var selectedSkillLevel: CookingSkillLevel = .beginner
    @State private var selectedCookingTools: Set<CookingTool> = []
    @State private var selectedPrepTime: PrepTime = .quick
    @State private var showSaveSuccess = false
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedTabIndex) {
                Text("Food").tag(0)
                Text("Allergy").tag(1)
                Text("Setup").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TabView(selection: $selectedTabIndex) {
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
                
                Form {
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
            
            VStack {
                if showSaveSuccess {
                    Text("Preferences saved successfully!")
                        .foregroundColor(.green)
                        .padding(.top, 20)
                }
                
                Button("Save Preferences") {
                    let preferences = UserPreferences(
                        // nationality: selectedNationality,
                        preferences: Array(selectedPreferences),
                        allergies: Array(selectedAllergies),
                        cookingSkillLevel: selectedSkillLevel,
                        cookingTools: selectedCookingTools,
                        maxPrepTime: selectedPrepTime
                    )
                    viewModel.updateUserPreferences(preferences)
                    showSaveSuccess = true
                    
                    // 1초 후에 성공 메시지를 숨깁니다
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
        .navigationTitle("User Preferences")
    }
}

struct UserPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        UserPreferencesView(
            viewModel: FridgeViewModel(),
            selectedTab: .constant(0)
        )
    }
}
