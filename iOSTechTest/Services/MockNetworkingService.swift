//
//  MockNetworkingService.swift
//  iOSTechTest
//
//  Created by Marco Abundo on 1/13/25.
//

final class MockNetworkingService: NetworkingServiceProtocol {
    func searchBySubject(_ subject: String, page: Int, limit: Int) async throws -> [BookItem] {
        // Return mock data
        return [
            BookItem(key: "mockBookID1", title: "Mock Book 1", coverId: 1234),
            BookItem(key: "mockBookID2", title: "Mock Book 2", coverId: 5678)
        ]
    }

    func getBookInfo(bookItem: BookItem) async throws -> BookInfo {
        return BookInfo(key: "mockBookID1", title: "Mock Book 1", coverId: 1234)
    }

    func isConnectedToNetwork() -> Bool {
        return true
    }
}
