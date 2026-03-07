import UIKit

class SignUpViewController: UIViewController {
    private let viewModel = SignUpViewModel()
    private let signUpView = SignUpView()
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.createAccountButton.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
    }
    
    @objc private func createAccountTapped() {
        Task {
            let result = await viewModel.createAccount(
                firstName: signUpView.firstNameTextField.text ?? "",
                lastName: signUpView.lastNameTextField.text ?? "",
                email: signUpView.emailTextField.text ?? "",
                password: signUpView.passwordTextField.text ?? ""
            )
            
            switch result {
            case .success:
                print("Account created successfully")
            case .failure(let error):
                print("Failed to create account: \(error)")
            }
        }
    }
}

