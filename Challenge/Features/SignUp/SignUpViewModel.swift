import Foundation
import Combine

enum SignUpState {
    case idle
    case loading
    case success
    case error(SignUpError)
}

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var state: SignUpState = .idle
    private let dataSource: UserDataSource
    
    init(dataSource: UserDataSource = UserDataSource()) {
        self.dataSource = dataSource
    }
    
    func createAccount(firstName: String, lastName: String, email: String, password: String) async {
        state = .loading
        
//        let model = SignUpModel(firstName: firstName, lastName: lastName, email: email, password: password)
        let model = SignUpModel.mock
        let result = await dataSource.createUser(model: model)
        
        switch result {
        case .success:
            state = .success
        case .failure(let error):
            if let signUpError = error as? SignUpError {
                state = .error(signUpError)
            } else {
                state = .error(.unknown("UNKNOWN_ERROR"))
            }
        }
    }
}
