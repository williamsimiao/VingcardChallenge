import Foundation

enum SignUpError: Error {
    case invalidEmail
    case weakPassword
    case userAlreadyExists
    case unknown(String)
    
    init(errorResponse: ErrorResponse) {
        switch errorResponse.code {
        case "INVALID_EMAIL":
            self = .invalidEmail
        case "WEAK_PASSWORD":
            self = .weakPassword
        case "USER_ALREADY_EXISTS":
            self = .userAlreadyExists
        default:
            self = .unknown(errorResponse.code)
        }
    }
}
