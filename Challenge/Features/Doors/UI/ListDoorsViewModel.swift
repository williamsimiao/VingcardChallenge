import Foundation
import Combine

enum ListDoorsState {
    case idle
    case loading
    case success
    case failure(DoorError)
}

@MainActor
class ListDoorsViewModel: ObservableObject {
    @Published var state: ListDoorsState = .idle
    @Published var doors: [DoorModel] = []
    private let dataSource: DoorDataSourceProtocol
    private var currentPage = 0
    private let pageSize = 20
    private var isLastPage = false
    private var isLoading = false
    private var currentSearchText: String?
    
    init(dataSource: DoorDataSourceProtocol = DoorDataSource()) {
        self.dataSource = dataSource
    }
    
    func getDoors() async {
        guard !isLoading else { return }
        isLoading = true
        currentSearchText = nil
        currentPage = 0
        state = .loading
        
        let result = await dataSource.getDoors(page: currentPage, size: pageSize)
        
        switch result {
        case .success(let response):
            isLastPage = response.last
            doors = response.content
            state = .success
        case .failure(let error):
            state = .failure(error)
        }
        isLoading = false
    }
    
    func findDoorByName(_ name: String) async {
        guard !isLoading else { return }
        isLoading = true
        currentSearchText = name
        currentPage = 0
        state = .loading
        
        let result = await dataSource.findDoorByName(name: name, page: currentPage, size: pageSize)
        
        switch result {
        case .success(let response):
            isLastPage = response.last
            doors = response.content
            state = .success
        case .failure(let error):
            state = .failure(error)
        }
        isLoading = false
    }
    
    func loadMoreDoors() async {
        guard !isLoading, !isLastPage else { return }
        isLoading = true
        currentPage += 1
        
        let result: Result<DoorsResponse, DoorError>
        if let searchText = currentSearchText {
            result = await dataSource.findDoorByName(name: searchText, page: currentPage, size: pageSize)
        } else {
            result = await dataSource.getDoors(page: currentPage, size: pageSize)
        }
        
        switch result {
        case .success(let response):
            isLastPage = response.last
            doors.append(contentsOf: response.content)
            state = .success
        case .failure:
            currentPage -= 1
        }
        isLoading = false
    }
}