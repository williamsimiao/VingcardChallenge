import SwiftUI

@main
struct ChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationViewControllerRepresentable()
        }
    }
}

struct NavigationViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewModel = SignInViewModel(dataSource: UserDataSource(), credentialsStorage: CredentialsStorage())
        let signInVC = SignInViewController(viewModel: viewModel)
        return UINavigationController(rootViewController: signInVC)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

