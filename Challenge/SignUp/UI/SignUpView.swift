import SwiftUI

struct SignUpView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 16) {
            TextField(NSLocalizedString("first_name", comment: ""), text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField(NSLocalizedString("last_name", comment: ""), text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField(NSLocalizedString("email", comment: ""), text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField(NSLocalizedString("password", comment: ""), text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(NSLocalizedString("create_account", comment: "")) {
                // Handle account creation
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    SignUpView()
}
