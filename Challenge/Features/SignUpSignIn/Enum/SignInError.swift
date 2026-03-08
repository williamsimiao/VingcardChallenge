import Foundation

enum SignInError: Error {
    case invalidCredentials
    case api(APIError)
    
    init(errorResponse: ErrorResponse) {
        switch errorResponse.code {
        case "INVALID_CREDENTIALS":
            self = .invalidCredentials
        default:
            self = .api(.unknown("\(errorResponse.code) - \(errorResponse.description)"))
        }
    }
    
    var localizedMessage: String {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("error_invalid_credentials", comment: "")
        case .api(let apiError):
            return apiError.localizedMessage
        }
    }
}
