import SwiftUI

struct LoginView: View {
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var goToInitialPreference = false
    @ObservedObject var viewModel: FridgeViewModel = FridgeViewModel()

    var body: some View {
        VStack {
            Spacer()
            Text("Fridge Mate")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            TextField("ID", text: $id)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            Button("Login") {
                goToInitialPreference = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
            .foregroundColor(.black)
            .padding(.horizontal)
            .padding(.top, 20)
            Spacer()
            Button("Sign Up") {
                // 추후 회원가입 구현
            }
            .padding(.bottom, 40)
        }
        .fullScreenCover(isPresented: $goToInitialPreference) {
            InitialPreferenceSelectView(
                viewModel: viewModel
            )
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
} 