import Foundation
import Combine

enum SignUpState {
    case idle
    case loading
    case success
    case failure(SignUpError)
}

class SignUpViewModel: ObservableObject {
    @Published var state: SignUpState = .idle
    private let dataSource: UserDataSourceProtocol
    
    init(dataSource: UserDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func createAccount(firstName: String, lastName: String, email: String, password: String) async {
        state = .loading
        
        let model = SignUpModel(firstName: firstName, lastName: lastName, email: email, password: password)
        let result = await dataSource.createUser(model: model)
        
        switch result {
        case .success:
            state = .success
        case .failure(let error):
            state = .failure(error)
        }
    }
}
