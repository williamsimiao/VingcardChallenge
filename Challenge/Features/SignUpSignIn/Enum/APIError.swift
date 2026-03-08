import Foundation

enum APIError: Error {
    case badServerResponse
    case unknown(String)
    
    var localizedMessage: String {
        switch self {
        case .badServerResponse:
            return NSLocalizedString("error_bad_server_response", comment: "")
        case .unknown(let description):
            return description
        }
    }
}
