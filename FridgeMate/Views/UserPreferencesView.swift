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
    @State private var selectedNationality: Nationality = .korean
    @State private var selectedPreferences: Set<FoodPreference> = []
    @State private var selectedAllergies: Set<Allergy> = []
    
    var body: some View {
        Form {
            Section(header: Text("Nationality")) {
                Picker("Select your nationality", selection: $selectedNationality) {
                    ForEach(Nationality.allCases, id: \.self) { nationality in
                        Text(nationality.rawValue).tag(nationality)
                    }
                }
            }
            
            Section(header: Text("Food Preferences")) {
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
            
            Section(header: Text("Allergies")) {
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
            
            Button("Save Preferences") {
                let preferences = UserPreferences(
                    nationality: selectedNationality,
                    preferences: Array(selectedPreferences),
                    allergies: Array(selectedAllergies)
                )
                viewModel.updateUserPreferences(preferences)
                selectedTab = 0
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("User Preferences")
    }
}

