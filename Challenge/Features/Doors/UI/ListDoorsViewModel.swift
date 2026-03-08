import Foundation
import Combine

enum ListDoorsState {
    case idle
    case loading
    case success([DoorModel])
    case failure(DoorError)
}

@MainActor
class ListDoorsViewModel: ObservableObject {
    @Published var state: ListDoorsState = .idle
    private let dataSource: DoorDataSourceProtocol
    private var currentPage = 0
    private let pageSize = 20
    
    init(dataSource: DoorDataSourceProtocol = DoorDataSource()) {
        self.dataSource = dataSource
    }
    
    func getDoors() async {
        state = .loading
        
        let result = await dataSource.getDoors(page: currentPage, size: pageSize)
        
        switch result {
        case .success(let response):
            state = .success(response.content)
        case .failure(let error):
            state = .failure(error)
        }
    }
}
