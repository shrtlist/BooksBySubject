//
//  iOSTechTestTests.swift
//  iOSTechTestTests
//
//  Created by Stone Zhang on 2023/11/26.
//

import XCTest
@testable import iOSTechTest

final class iOSTechTestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        PersistenceManager.shared.deleteAllCache()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testFetchBooks() async throws {
        // Arrange
        let mockNetworkingService = MockNetworkingService()

        // Inject the mock service
        let viewModel = BookListViewModel(networkingService: mockNetworkingService)

        // Act
        await viewModel.searchBooks(for: "subject")

        // Assert
        XCTAssertGreaterThan(viewModel.bookItems.count, 0, "ViewModel should have multiple books.")
    }

    @MainActor
    func testFetchBookDetails() async throws {
        // Arrange
        let mockNetworkingService = MockNetworkingService()

        // Inject the mock service
        let viewModel = BookListViewModel(networkingService: mockNetworkingService)

        // Act
        await viewModel.searchBooks(for: "subject")

        guard let bookItem = viewModel.bookItems.first else {
            XCTFail("ViewModel should fetch 1 book.")
            return
        }

        let bookInfo = await viewModel.fetchBookDetails(bookItem: bookItem)

        // Assert
        XCTAssertNotNil(bookInfo)
    }

    func testPersistenceManager() throws {
        let key = "testBookID"
        let title = "Test Book"
        let authors = "Test Author"
        let subject = "subject"

        // Arrange
        let persistenceManager = PersistenceManager.shared
        let context = persistenceManager.context

        // Create a sample cached book in Core Data
        let cachedBook = Book(context: context)
        cachedBook.key = key
        cachedBook.title = title
        cachedBook.authors = authors
        cachedBook.subject = subject
        cachedBook.timestamp = Date()
        persistenceManager.saveContext()

        let cachedBooks = persistenceManager.fetchCachedBooks(for: subject)

        // Assert
        XCTAssertEqual(cachedBooks.count, 1, "ViewModel should have 1 cached book.")
        XCTAssertEqual(cachedBooks.first?.key, key, "The cached book key should match.")
        XCTAssertEqual(cachedBooks.first?.title, title, "The cached book title should match.")
        XCTAssertEqual(cachedBooks.first?.authors, authors, "The cached book author should match.")
    }
}
