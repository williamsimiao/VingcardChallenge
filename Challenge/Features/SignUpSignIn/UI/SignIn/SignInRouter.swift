import UIKit

enum SignInRoute {
    case signUp
    case listDoors
}

class SignInRouter {
    weak var viewController: UIViewController?
    
    func navigate(to route: SignInRoute) {
        switch route {
        case .signUp:
            let viewModel = SignUpViewModel(dataSource: UserDataSource())
            let signUpVC = SignUpViewController(viewModel: viewModel)
            viewController?.navigationController?.pushViewController(signUpVC, animated: true)
        case .listDoors:
            let viewModel = ListDoorsViewModel(dataSource: DoorDataSource())
            let listDoorsVC = ListDoorsViewController(viewModel: viewModel)
            viewController?.navigationController?.pushViewController(listDoorsVC, animated: true)
        }
    }
}
