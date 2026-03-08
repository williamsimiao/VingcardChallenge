import Foundation

class UserDataSource {
    
    func createUser(model: SignUpModel) async -> Result<Void, SignUpError> {
        do {
            let url = URL(string: APIConfig.baseURL + "users/signup")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(model)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.api(.badServerResponse))
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                return .success(())
            } else {
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    return .failure(SignUpError(errorResponse: errorResponse))
                }
                return .failure(.api(.badServerResponse))
            }
        } catch {
            return .failure(.api(.badServerResponse))
        }
    }
    
    func loginUser(email: String, password: String) async -> Result<String, SignInError> {
        do {
            let url = URL(string: APIConfig.baseURL + "users/signin")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = ["email": email, "password": password]
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.api(.badServerResponse))
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                let loginResponse = try JSONDecoder().decode(SignInResponse.self, from: data)
                return .success(loginResponse.token)
            } else {
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    return .failure(SignInError(errorResponse: errorResponse))
                }
                return .failure(.api(.badServerResponse))
            }
        } catch {
            return .failure(.api(.badServerResponse))
        }
    }
}

