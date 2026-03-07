import Foundation

class UserDataSource {
    private let baseURL: String
    
    init(baseURL: String = APIConfig.baseURL) {
        self.baseURL = baseURL
    }
    
    func createUser(model: SignUpModel) async throws {
        let url = URL(string: baseURL + "users/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(model)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
