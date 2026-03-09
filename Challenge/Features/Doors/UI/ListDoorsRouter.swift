import UIKit

enum ListDoorsRoute {
    case back
}

class ListDoorsRouter {
    weak var viewController: UIViewController?
    
    func navigate(to route: ListDoorsRoute) {
        switch route {
        case .back:
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
