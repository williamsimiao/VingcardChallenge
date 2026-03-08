import UIKit
import Combine

class SignInViewController: UIViewController {
    private let viewModel = SignInViewModel()
    private let signInView = SignInView()
    private var cancellables = Set<AnyCancellable>()
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        signInView.signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        observeState()
    }
    
    private func setupLoadingView() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.hidesWhenStopped = true
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func observeState() {
        viewModel.$state
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: SignInState) {
        switch state {
        case .idle:
            loadingView.stopAnimating()
            view.isUserInteractionEnabled = true
        case .loading:
            loadingView.startAnimating()
            view.isUserInteractionEnabled = false
        case .success(let token):
            loadingView.stopAnimating()
            view.isUserInteractionEnabled = true
            print("Signed in with token: \(token)")
        case .failure(let error):
            loadingView.stopAnimating()
            view.isUserInteractionEnabled = true
            showError(error)
        }
    }
    
    private func showError(_ error: SignInError) {
        let alert = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message: error.localizedMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func signInTapped() {
        Task {
            await viewModel.signIn(
                email: signInView.emailTextField.text ?? "",
                password: signInView.passwordTextField.text ?? ""
            )
        }
    }
}
