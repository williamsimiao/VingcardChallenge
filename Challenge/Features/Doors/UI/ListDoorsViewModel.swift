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
    
    private var allDoorsPage = 0
    private var allDoorsIsLastPage = false
    
    private var searchPage = 0
    private var searchIsLastPage = false
    private var searchText: String?
    
    private let pageSize = 20
    private var isLoading = false
    
    init(dataSource: DoorDataSourceProtocol = DoorDataSource()) {
        self.dataSource = dataSource
    }
    
    func getDoors(loadMore: Bool = false) async {
        guard !isLoading else { return }
        guard !loadMore || !allDoorsIsLastPage else { return }
        
        isLoading = true
        searchText = nil
        
        if !loadMore {
            allDoorsPage = 0
            state = .loading
        } else {
            allDoorsPage += 1
        }
        
        let result = await dataSource.getDoors(page: allDoorsPage, size: pageSize)
        
        switch result {
        case .success(let response):
            allDoorsIsLastPage = response.last
            if loadMore {
                doors.append(contentsOf: response.content)
            } else {
                doors = response.content
            }
            state = .success
        case .failure(let error):
            if loadMore {
                allDoorsPage -= 1
            } else {
                state = .failure(error)
            }
        }
        isLoading = false
    }
    
    func findDoorByName(_ name: String, loadMore: Bool = false) async {
        guard !isLoading else { return }
        guard !loadMore || !searchIsLastPage else { return }
        
        isLoading = true
        searchText = name
        
        if !loadMore {
            searchPage = 0
            state = .loading
        } else {
            searchPage += 1
        }
        
        let result = await dataSource.findDoorByName(name: name, page: searchPage, size: pageSize)
        
        switch result {
        case .success(let response):
            searchIsLastPage = response.last
            if loadMore {
                doors.append(contentsOf: response.content)
            } else {
                doors = response.content
            }
            state = .success
        case .failure(let error):
            if loadMore {
                searchPage -= 1
            } else {
                state = .failure(error)
            }
        }
        isLoading = false
    }
}