import Foundation

enum DoorError: Error {
    case api(APIError)
    
    init(errorResponse: ErrorResponse) {
        self = .api(.unknown("\(errorResponse.code) - \(errorResponse.description)"))
    }
    
    var localizedMessage: String {
        switch self {
        case .api(let apiError):
            return apiError.localizedMessage
        }
    }
}
