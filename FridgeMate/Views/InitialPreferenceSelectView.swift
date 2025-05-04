import SwiftUI

struct InitialPreferenceSelectView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @State private var selectedPreferences: Set<FoodPreference> = []
    @State private var selectedAllergies: Set<Allergy> = []
    @State private var selectedSkillLevel: CookingSkillLevel = .beginner
    @State private var selectedCookingTools: Set<CookingTool> = []
    @State private var selectedPrepTime: PrepTime = .quick
    @State private var goToUserPreferences = false

    var body: some View {
        VStack {
            Text("Welcome to FridgeMate")
                .font(.title)
                .padding()
            Form {
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
                }
            }
            Button("Save") {
                let preferences = UserPreferences(
                    preferences: Array(selectedPreferences),
                    allergies: Array(selectedAllergies),
                    cookingSkillLevel: selectedSkillLevel,
                    cookingTools: selectedCookingTools,
                    maxPrepTime: selectedPrepTime
                )
                viewModel.updateUserPreferences(preferences)
                goToUserPreferences = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .fullScreenCover(isPresented: $goToUserPreferences) {
            UserPreferencesView(
                viewModel: viewModel,
                selectedTab: .constant(0)
            )
        }
    }
}

struct InitialPreferenceSelectView_Previews: PreviewProvider {
    static var previews: some View {
        InitialPreferenceSelectView(viewModel: FridgeViewModel())
    }
} 
