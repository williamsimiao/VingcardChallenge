import UIKit
import Combine

class SignUpViewController: UIViewController {
    private let viewModel = SignUpViewModel()
    private let signUpView = SignUpView()
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.createAccountButton.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
        observeState()
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
            break
        case .loading:
            print("Loading...")
        case .success:
            print("Account created successfully")
        case .error(let error):
            print("Failed to create account: \(error)")
        }
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

