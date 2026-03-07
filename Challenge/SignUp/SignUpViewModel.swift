import Foundation
internal import Combine

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    
    private let dataSource: UserDataSource
    
    init(dataSource: UserDataSource = UserDataSource()) {
        self.dataSource = dataSource
    }
    
    func createAccount() async throws {
        let model = SignUpModel(firstName: firstName, lastName: lastName, email: email, password: password)
        try await dataSource.createUser(model: model)
    }
}
