import Foundation
import Security

class CredentialsStorage {
    static let shared = CredentialsStorage()
    
    private let emailKey = "stored_email"
    private let passwordKey = "stored_password"
    private let service = "com.challenge.app"
    
    private init() {}
    
    func saveCredentials(email: String, password: String) {
        UserDefaults.standard.set(email, forKey: emailKey)
        saveToKeychain(key: passwordKey, value: password)
    }
    
    func getCredentials() -> (email: String, password: String)? {
        guard let email = UserDefaults.standard.string(forKey: emailKey),
              let password = getFromKeychain(key: passwordKey) else {
            return nil
        }
        return (email, password)
    }
    
    func clearCredentials() {
        UserDefaults.standard.removeObject(forKey: emailKey)
        deleteFromKeychain(key: passwordKey)
    }
    
    private func saveToKeychain(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func getFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let password = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return password
    }
    
    private func deleteFromKeychain(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
