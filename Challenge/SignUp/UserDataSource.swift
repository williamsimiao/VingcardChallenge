import Foundation

class UserDataSource {
    
    func createUser(model: SignUpModel) async -> Result<Void, Error> {
        do {
            let url = URL(string: APIConfig.baseURL + "users/signup")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(model)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return .failure(URLError(.badServerResponse))
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

