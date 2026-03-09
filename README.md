## Info
seniority: Senior

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.0+

## Setup

1. Clone the repository
2. Open the `.xcodeproj` file in Xcode
3. Build and run


## Feature Archtecture and Development process

Utilizei MVVM para o contexto de UI e dominio. As classes DataSource realizam o setup das requisições à API e tratamento de erros

A IA usado no projeto foi a Amazon Q. Na fase inicial a interação rápida entre o retorno dos prompts e a estrutura de projeto almejada, pedindo ajustes e especificando padrões, permitiu acelerar a caracterização das classes viewModel e DataSource. Vencida esta etapa base durante a implementação da tela de SignUp, foi possivel gerar o código para as SignInViewModel, ListDoorViewModel, DoorDataSource e os enum de erros. Apenas ajustando o necessário.

Para criação das interfaces a geração de código simplificou muito o trabalho e permitiu dedicar tempo a algumas melhorias de usabilidade. 

## SignUp and SignIn feature highlights

Implementação completa do fluxo de autenticação utilizando MVVM com separação clara de responsabilidades. O UserDataSource centraliza as chamadas de API (signup e signin), gerenciando a criação de usuários e login. Após login bem-sucedido, o token é armazenado no NetworkClient para autenticação de requisições subsequentes, e as credenciais são salvas de forma segura no Keychain através do CredentialsStorage singleton.

A feature inclui tratamento de erros com mensagens específicas (email já existente, credenciais inválidas) totalmente localizadas em português e inglês. O SignInViewController implementa auto-login carregando credenciais salvas automaticamente ao iniciar. Os campos de entrada são limpos ao sair das telas (viewDidDisappear) para garantir privacidade. A navegação entre SignIn/SignUp e para a lista de portas é gerenciada por routers dedicados com enums de rotas, mantendo o código organizad.

## List Doors feature highlights

Feature de listagem de portas com busca em tempo real e paginação infinita otimizada. O DoorDataSource fornece dois endpoints: getDoors para listar todas as portas e findDoorByName para busca por nome com encoding de URL. Com propósito de legibilidade a ListDoorsViewModel gerencia os estados de paginação dos endpoints separadamente. A busca é implementada com UISearchController integrado à navigation bar através do protocolo UISearchResultsUpdating, atualizando os resultados conforme o usuário digita. O scroll infinito detecta quando o usuário está próximo do final da lista (threshold de 100px) e carrega automaticamente a próxima página usando o parâmetro loadMore. A tableView exibe o nome das portas de forma simples e eficiente. O ViewModel mantém o array de portas e coordena estados (idle, loading, success, failure) para atualizar a UI apropriadamente. Inclui botão "Sign Out" na navigation bar que limpa credenciais e retorna à tela de login, com back button oculto para melhor UX.

## Network

O NetworkClient é uma camada genérica de networking que gerencia todas as requisições HTTP da aplicação. Utiliza URLSession com async/await para chamadas assíncronas modernas e type-safe. Suporta métodos GET e POST com encoding automático de body usando JSONEncoder. O cliente armazena o token após login e o inclui automaticamente no header Authorization de todas as requisições subsequentes. O error retornado pela API é decodificado para o objeto ErrorResponse e permite que cada feature defina seu próprio errorHandler para converter ErrorResponse em erros de domínio específicos (SignUpError, SignInError, DoorError). Cada enum de erro implementa localizedMessage para exibir mensagens apropriadas ao usuário. A arquitetura permite fácil extensão para novos endpoints mantendo consistência no tratamento de erros e autenticação em toda a aplicação.

