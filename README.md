## Info
seniority: Senior
The mandatory features were implemented but there was no time left for one optinal feature.

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.0+

## Setup

1. Clone the repository
2. Open the `.xcodeproj` file in Xcode
3. Build and run


## Feature Architecture and Development process

I used MVVM for the UI and domain context. The DataSource classes handle API request setup and error handling.

The AI used in the project was Amazon Q. In the initial phase, the rapid interaction between prompt responses and the desired project structure, requesting adjustments and specifying patterns, allowed me to accelerate the characterization of ViewModel and DataSource classes. Once this base stage was completed during the SignUp screen implementation, it was possible to generate code for SignInViewModel, ListDoorViewModel, DoorDataSource, and error enums. Onlywith some adjustments prompts.

For interface creation, code generation greatly simplified the work and allowed me to dedicate time to some usability improvements.

## SignUp and SignIn feature highlights

Complete authentication flow implementation using MVVM with clear separation of responsibilities. The UserDataSource centralizes API calls (signup and signin), managing user creation and login. After successful login, the token is stored in NetworkClient for subsequent request authentication, and credentials are securely saved in Keychain through the CredentialsStorage singleton.

The feature includes error handling with specific messages (email already exists, invalid credentials) fully localized in Portuguese and English. The SignInViewController implements auto-login by automatically loading saved credentials on startup. Input fields are cleared when leaving screens (viewDidDisappear) to ensure privacy. Navigation between SignIn/SignUp and the doors list is managed by dedicated routers with route enums, keeping the code organized.

## List Doors feature highlights

Doors listing feature with real-time search and infinite pagination. The DoorDataSource provides two endpoints: getDoors to list all doors and findDoorByName for name search with URL encoding. For readability purposes, the ListDoorsViewModel manages pagination states for each endpoint separately. Search is implemented with UISearchController integrated into the navigation bar through the UISearchResultsUpdating protocol, updating results as the user types. Infinite scroll detects when the user is near the end of the list (100px threshold) and automatically loads the next page using the loadMore parameter. The tableView displays door names simply and efficiently. The ViewModel maintains the doors array and coordinates states (idle, loading, success, failure) to update the UI appropriately. Includes a "Sign Out" button in the navigation bar that clears credentials and returns to the login screen, with hidden back button for better UX.

## Network

NetworkClient is a generic networking layer that manages all HTTP requests in the application. Uses URLSession with async/await for modern, type-safe asynchronous calls. Supports GET and POST methods with automatic body encoding using JSONEncoder. The client stores the token after login and automatically includes it in the Authorization header of all subsequent requests. The error returned by the API is decoded into the ErrorResponse object and allows each feature to define its own errorHandler to convert ErrorResponse into specific domain errors (SignUpError, SignInError, DoorError). Each error enum implements localizedMessage to display appropriate messages to the user. The architecture allows easy extension for new endpoints while maintaining consistency in error handling and authentication throughout the application.

