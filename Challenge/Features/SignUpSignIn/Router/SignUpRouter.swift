import UIKit

enum SignUpRoute {
    case back
}

class SignUpRouter {
    weak var viewController: UIViewController?
    
    func navigate(to route: SignUpRoute) {
        switch route {
        case .back:
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
