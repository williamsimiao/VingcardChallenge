import Foundation

struct SignInModel: Encodable {
    let email: String
    let password: String
    
    static var mock: SignInModel {
        SignInModel(
            email: "williamsimiao@gmail.com",
            password: "Secure90!"
        )
    }
}
