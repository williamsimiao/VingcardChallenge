import Foundation

enum APIConfig {
    static let baseURL: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError("BaseURL not found in Info.plist")
        }
        return url
    }()
}
