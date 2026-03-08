import Foundation

enum SignUpError: Error {
    case serverValidation
    case weakPassword
    case emailAlreadyExists
    case api(APIError)
    
    init(errorResponse: ErrorResponse) {
        switch errorResponse.code {
        case "VALIDATION_ERROR":
            self = .serverValidation
        case "WEAK_PASSWORD":
            self = .weakPassword
        case "EMAIL_ALREADY_EXISTS":
            self = .emailAlreadyExists
        default:
            self = .api(.unknown("\(errorResponse.code) - \(errorResponse.description)"))
        }
    }
    
    var localizedMessage: String {
        switch self {
        case .serverValidation:
            return NSLocalizedString("error_server_validation", comment: "")
        case .weakPassword:
            return NSLocalizedString("error_weak_password", comment: "")
        case .emailAlreadyExists:
            return NSLocalizedString("error_email_already_exists", comment: "")
        case .api(let apiError):
            return apiError.localizedMessage
        }
    }
}
