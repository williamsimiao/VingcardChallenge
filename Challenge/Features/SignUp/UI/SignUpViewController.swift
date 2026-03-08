import UIKit
import Combine

class SignUpViewController: UIViewController {
    private let viewModel = SignUpViewModel()
    private let signUpView = SignUpView()
    private var cancellables = Set<AnyCancellable>()
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        signUpView.createAccountButton.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
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
    
    private func handleState(_ state: SignUpState) {
        switch state {
        case .idle:
            loadingView.stopAnimating()
            view.isUserInteractionEnabled = true
        case .loading:
            loadingView.startAnimating()
            view.isUserInteractionEnabled = false
        case .success:
            loadingView.stopAnimating()
            view.isUserInteractionEnabled = true
        case .failure(let error):
            loadingView.stopAnimating()
            view.isUserInteractionEnabled = true
            showError(error)
        }
    }
    
    private func showError(_ error: SignUpError) {
        let message: String
        switch error {
        case .serverValidation:
            message = NSLocalizedString("error_server_validation", comment: "")
        case .weakPassword:
            message = NSLocalizedString("error_weak_password", comment: "")
        case .emailAlreadyExists:
            message = NSLocalizedString("error_email_already_exists", comment: "")
        case .unknown(let description):
            message = description
        }
        
        let alert = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func createAccountTapped() {
        Task {
            await viewModel.createAccount(
                firstName: signUpView.firstNameTextField.text ?? "",
                lastName: signUpView.lastNameTextField.text ?? "",
                email: signUpView.emailTextField.text ?? "",
                password: signUpView.passwordTextField.text ?? ""
            )
        }
    }
}

