import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool    // Controls whether the splash screen is still visible

    var body: some View {
        VStack {
            Spacer()
            // App title on splash screen
            Text("Fridge Mate")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }
        .onAppear {
            // Dismiss splash after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = false
                }
            }
        }
    }
}
