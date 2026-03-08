import Foundation

enum SignUpError: Error {
    case serverValidation
    case weakPassword
    case emailAlreadyExists
    case unknown(String)
    
    init(errorResponse: ErrorResponse) {
        switch errorResponse.code {
        case "VALIDATION_ERROR":
            self = .serverValidation
        case "WEAK_PASSWORD":
            self = .weakPassword
        case "EMAIL_ALREADY_EXISTS":
            self = .emailAlreadyExists
        default:
            self = .unknown("\(errorResponse.code) - \(errorResponse.description)")
        }
    }
}
