import Foundation

struct SignUpModel: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}
