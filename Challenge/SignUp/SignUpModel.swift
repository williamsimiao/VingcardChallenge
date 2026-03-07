import Foundation

struct SignUpModel: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    
    static var mock: SignUpModel {
        SignUpModel(
            firstName: "william",
            lastName: "simiao",
            email: "williamsimiao2@gmail.com",
            password: "Secure90!"
        )
    }
}
