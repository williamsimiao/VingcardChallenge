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
    
    init(dataSource: UserDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func signIn(email: String, password: String) async {
        state = .loading
        
//        let model = SignInModel(email: email, password: password)
        let model = SignInModel.mock
        let result = await dataSource.loginUser(model: model)
        
        switch result {
        case .success:
            state = .success
        case .failure(let error):
            state = .failure(error)
        }
    }
}
