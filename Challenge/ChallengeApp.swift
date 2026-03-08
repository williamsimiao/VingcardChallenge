import SwiftUI

@main
struct ChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            SignInViewControllerRepresentable()
        }
    }
}

struct SignInViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SignInViewController {
        SignInViewController()
    }
    
    func updateUIViewController(_ uiViewController: SignInViewController, context: Context) {}
}

