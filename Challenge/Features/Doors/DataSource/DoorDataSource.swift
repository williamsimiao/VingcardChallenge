import Foundation

protocol DoorDataSourceProtocol {
    func getDoors(page: Int, size: Int) async -> Result<DoorsResponse, DoorError>
}

class DoorDataSource: DoorDataSourceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = .shared) {
        self.networkClient = networkClient
    }
    
    func getDoors(page: Int, size: Int) async -> Result<DoorsResponse, DoorError> {
        let result: Result<DoorsResponse, DoorError> = await networkClient.request(
            endpoint: "doors?page=\(page)&size=\(size)",
            method: "GET",
            responseType: DoorsResponse.self,
            errorHandler: { DoorError(errorResponse: $0) }
        )
        
        return result
    }
}
