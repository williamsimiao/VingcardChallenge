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
    private let dataSource: UserDataSourceProtocol
    private let credentialsStorage: CredentialsStorageProtocol
    
    init(dataSource: UserDataSourceProtocol, credentialsStorage: CredentialsStorageProtocol) {
        self.dataSource = dataSource
        self.credentialsStorage = credentialsStorage
    }
    
    func getStoredCredentials() -> (email: String, password: String)? {
        return credentialsStorage.getCredentials()
    }
    
    func signIn(email: String, password: String) async {
        state = .loading
        
        let model = SignInModel(email: email, password: password)
        let result = await dataSource.loginUser(model: model)
        
        switch result {
        case .success:
            credentialsStorage.saveCredentials(email: email, password: password)
            state = .success
        case .failure(let error):
            state = .failure(error)
        }
    }
}
