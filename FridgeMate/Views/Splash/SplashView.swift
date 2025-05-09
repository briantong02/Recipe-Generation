import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool    // Controls whether the splash screen is still visible
    
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image("fridge")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            scale = 5.0
                            opacity = 0.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            isActive = false
                        }
                    }
                
                
                // App title on splash screen
                Text("Fridge Mate")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .opacity(opacity)
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
}
