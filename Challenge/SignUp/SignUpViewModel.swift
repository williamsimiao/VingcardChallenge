import Foundation

@MainActor
class SignUpViewModel {
    private let dataSource: UserDataSource
    
    init(dataSource: UserDataSource = UserDataSource()) {
        self.dataSource = dataSource
    }
    
    func createAccount(firstName: String, lastName: String, email: String, password: String) async -> Result<Void, Error> {
        let model = SignUpModel(firstName: firstName, lastName: lastName, email: email, password: password)
        return await dataSource.createUser(model: model)
    }
}
