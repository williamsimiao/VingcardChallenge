# Challenge

iOS project

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.0+

## Setup

1. Clone the repository
2. Open the `.xcodeproj` or `.xcworkspace` file in Xcode
3. Build and run

## License

MIT

## Feature Archtecture

Utilizei MVVM para o contexto de UI e dominio, para as centralizar as requests à API criei uma classe de remoteDataSource para agrupar os endpoints relacionados as features.  

Utilizei IA de forma mais interativa durante o desenvolvimento da primeira feature buscando especificar a estrutura a ser replicada nas features seguites.
O dataSorce realiza as requicoes, faz o decode da response e inicializa o objeto responseModel se necessário.
A viewModel coordena o state da tela de acordo com retorno da request
## SignUp and SignUp feature
