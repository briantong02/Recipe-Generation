import SwiftUI

struct RecipeFilterView: View {
    @Binding var selectedCookingTime: CookingTimeFilter
    @Binding var isFiltering: Bool
    
    var onFilter: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Cooking Time")
                    .font(.headline)
                
                Picker("Select cooking time", selection: $selectedCookingTime) {
                    ForEach(CookingTimeFilter.allCases, id: \.self) { filter in
                        Text(filter.displayText).tag(filter)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Spacer()
                
                Button(action: {
                    onFilter()
                }) {
                    Text("Filter")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

enum CookingTimeFilter: String, CaseIterable {
    case all = "All"
    case under15 = "Under 15 min"
    case under30 = "Under 30 min"
    case under60 = "Under 1 hour"
    case over60 = "Over 1 hour"
    
    var displayText: String {
        self.rawValue
    }
    
    func matches(_ cookingTime: Int) -> Bool {
        switch self {
        case .all:
            return true
        case .under15:
            return cookingTime <= 15
        case .under30:
            return cookingTime <= 30
        case .under60:
            return cookingTime <= 60
        case .over60:
            return cookingTime > 60
        }
    }
}

#Preview {
    RecipeFilterView(
        selectedCookingTime: .constant(.all),
        isFiltering: .constant(false),
        onFilter: {}
    )
} 
