import Foundation
import Combine

enum SignInState {
    case idle
    case loading
    case success(String)
    case failure(SignInError)
}

@MainActor
class SignInViewModel: ObservableObject {
    @Published var state: SignInState = .idle
    private let dataSource: UserDataSource
    
    init(dataSource: UserDataSource = UserDataSource()) {
        self.dataSource = dataSource
    }
    
    func signIn(email: String, password: String) async {
        state = .loading
        
        let result = await dataSource.loginUser(email: email, password: password)
        
        switch result {
        case .success(let token):
            state = .success(token)
        case .failure(let error):
            if let signInError = error as? SignInError {
                state = .failure(signInError)
            } else {
                state = .failure(.unknown("UNKNOWN_ERROR"))
            }
        }
    }
}
