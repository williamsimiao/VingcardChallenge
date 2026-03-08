import UIKit
import Combine

class SignUpViewController: UIViewController {
    private let viewModel: SignUpViewModel
    private let signUpView = SignUpView()
    private let router = SignUpRouter()
    private var cancellables = Set<AnyCancellable>()
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router.viewController = self
        setupLoadingView()
        signUpView.createAccountButton.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
        observeState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        signUpView.firstNameTextField.text = ""
        signUpView.lastNameTextField.text = ""
        signUpView.emailTextField.text = ""
        signUpView.passwordTextField.text = ""
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
            router.navigate(to: .back)
        case .failure(let error):
            loadingView.stopAnimating()
            view.isUserInteractionEnabled = true
            showError(error)
        }
    }
    
    private func showError(_ error: SignUpError) {
        let alert = UIAlertController(title: NSLocalizedString("error_title", comment: ""),
                                      message: error.localizedMessage,
                                      preferredStyle: .alert)
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

