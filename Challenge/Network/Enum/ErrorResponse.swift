import Foundation

struct ErrorResponse: Decodable {
    let code: String
    let description: String
}
