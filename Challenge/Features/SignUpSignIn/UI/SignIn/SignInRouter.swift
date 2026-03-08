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
            let signUpVC = SignUpViewController()
            viewController?.navigationController?.pushViewController(signUpVC, animated: true)
        case .listDoors:
            let listDoorsVC = ListDoorsViewController()
            viewController?.navigationController?.pushViewController(listDoorsVC, animated: true)
        }
    }
}
