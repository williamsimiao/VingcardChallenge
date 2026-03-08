import Foundation

protocol UserDataSourceProtocol {
    func createUser(model: SignUpModel) async -> Result<Void, SignUpError>
    func loginUser(model: SignInModel) async -> Result<Void, SignInError>
}

class UserDataSource: UserDataSourceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = .shared) {
        self.networkClient = networkClient
    }
    
    func createUser(model: SignUpModel) async -> Result<Void, SignUpError> {
        struct EmptyResponse: Decodable {}
        
        let result: Result<EmptyResponse, SignUpError> = await networkClient.request(
            endpoint: "users/signup",
            method: "POST",
            body: model,
            responseType: EmptyResponse.self,
            errorHandler: { SignUpError(errorResponse: $0) }
        )
        
        return result.map { _ in () }
    }
    
    func loginUser(model: SignInModel) async -> Result<Void, SignInError> {
        let result: Result<SignInResponse, SignInError> = await networkClient.request(
            endpoint: "users/signin",
            method: "POST",
            body: model,
            responseType: SignInResponse.self,
            errorHandler: { SignInError(errorResponse: $0) }
        )
        
        if case .success(let response) = result {
            networkClient.token = response.token
            CredentialsStorage.shared.saveCredentials(email: model.email, password: model.password)
        }
        
        return result.map { _ in () }
    }
}

