import Foundation
import Combine

enum SignInState {
    case idle
    case loading
    case success
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
        case .success:
            state = .success
        case .failure(let error):
            state = .failure(error)
        }
    }
}
