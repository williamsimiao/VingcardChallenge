import Foundation

class NetworkClient {
    private let baseURL: String
    
    init(baseURL: String = APIConfig.baseURL) {
        self.baseURL = baseURL
    }
    
    func request<T: Decodable, E: Error>(
        endpoint: String,
        method: String,
        body: Encodable? = nil,
        responseType: T.Type,
        errorHandler: (ErrorResponse) -> E
    ) async -> Result<T, E> {
        do {
            guard let requestURL = URL(string: baseURL + endpoint) else {
                fatalError("Invalid URL")
            }
            
            var request = URLRequest(url: requestURL)
            request.httpMethod = method
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let body = body {
                request.httpBody = try JSONEncoder().encode(body)
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(errorHandler(ErrorResponse(code: "BAD_SERVER_RESPONSE", description: "Invalid response")))
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return .success(decoded)
            } else {
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    return .failure(errorHandler(errorResponse))
                }
                return .failure(errorHandler(ErrorResponse(code: "BAD_SERVER_RESPONSE", description: "Server error")))
            }
        } catch {
            return .failure(errorHandler(ErrorResponse(code: "NETWORK_ERROR", description: error.localizedDescription)))
        }
    }
}
