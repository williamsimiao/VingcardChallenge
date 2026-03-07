import UIKit

class SignUpViewController: UIViewController {
    private let viewModel = SignUpViewModel()
    private let signUpView = SignUpView()
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        signUpView.createAccountButton.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        signUpView.firstNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        signUpView.lastNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        signUpView.emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        signUpView.passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @objc private func textFieldChanged(_ textField: UITextField) {
        switch textField {
        case signUpView.firstNameTextField:
            viewModel.firstName = textField.text ?? ""
        case signUpView.lastNameTextField:
            viewModel.lastName = textField.text ?? ""
        case signUpView.emailTextField:
            viewModel.email = textField.text ?? ""
        case signUpView.passwordTextField:
            viewModel.password = textField.text ?? ""
        default:
            break
        }
    }
    
    @objc private func createAccountTapped() {
        Task {
            try? await viewModel.createAccount()
        }
    }
}

