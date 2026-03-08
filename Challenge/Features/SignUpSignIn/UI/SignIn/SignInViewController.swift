import UIKit
import Combine

class SignInViewController: UIViewController {
    private let viewModel: SignInViewModel
    private let signInView = SignInView()
    private let router = SignInRouter()
    private var cancellables = Set<AnyCancellable>()
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router.viewController = self
        setupLoadingView()
        signInView.signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        signInView.signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        observeState()
        loadStoredCredentials()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        signInView.emailTextField.text = ""
        signInView.passwordTextField.text = ""
    }
    
    private func loadStoredCredentials() {
        if let credentials = viewModel.getStoredCredentials() {
            signInView.emailTextField.text = credentials.email
            signInView.passwordTextField.text = credentials.password
            Task {
                await viewModel.signIn(email: credentials.email, password: credentials.password)
            }
        }
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
        case .success:
            loadingView.stopAnimating()
            view.isUserInteractionEnabled = true
            router.navigate(to: .listDoors)
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
    
    @objc private func signUpTapped() {
        router.navigate(to: .signUp)
    }
}
