import Foundation

enum SignInError: Error {
    case invalidCredentials
    case unknown(String)
    
    init(errorResponse: ErrorResponse) {
        switch errorResponse.code {
        case "INVALID_CREDENTIALS":
            self = .invalidCredentials
        default:
            self = .unknown("\(errorResponse.code) - \(errorResponse.description)")
        }
    }
    
    var localizedMessage: String {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("error_invalid_credentials", comment: "")
        case .unknown(let description):
            return description
        }
    }
}
