//
//  BookListViewModel.swift
//  iOSTechTest
//
//  Created by Marco Abundo on 1/8/25.
//

import Foundation
import Combine

@MainActor
final class BookListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var bookItems: [BookItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Properties
    private var currentPage: Int = 0
    private var hasMorePages: Bool = true
    private var searchQuery: String = ""
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init() {
        deleteExpiredCache()
    }

    // MARK: - Fetch Books
    func searchBooks(for subject: String) async {
        guard !isLoading else { return }

        // If the query changes, reset the state
        if searchQuery != subject {
            resetState()
            searchQuery = subject
        }

        // Fetch books from cache if offline
        if !NetworkingService.shared.isConnectedToNetwork() {
            loadCachedBooks(for: subject)
            return
        }

        isLoading = true

        do {
            bookItems = try await NetworkingService.shared.searchBySubject(subject, page: currentPage)
            PersistenceManager.shared.saveBooks(bookItems, subject: subject)

            isLoading = false
            hasMorePages = !bookItems.isEmpty
            currentPage += 1
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    func fetchBookDetails(bookItem: BookItem) async -> BookInfo? {
        var bookInfo: BookInfo?

        // Fetch book from cache if offline
        if !NetworkingService.shared.isConnectedToNetwork() {
            if let cachedBook = PersistenceManager.shared.fetchBookDetails(bookId: bookItem.key) {
                bookInfo = BookInfo(
                    key: bookItem.key,
                    title: bookItem.title,
                    authors: bookItem.authors,
                    coverId: bookItem.coverId,
                    description: cachedBook.bookDescription ?? "No description available.",
                    firstPublishDate: cachedBook.firstPublishDate ?? "Unknown Date" // Default for optional publish date
                )
            }
        } else {
            // If no cache, fetch from API
            isLoading = true

            do {
                let fetchedBookInfo = try await NetworkingService.shared.getBookInfo(bookItem: bookItem)
                bookInfo = fetchedBookInfo

                PersistenceManager.shared.saveBookInfo(fetchedBookInfo)

                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }

        return bookInfo
    }

    // MARK: - Load Cached Books

    private func loadCachedBooks(for subject: String) {
        let books = PersistenceManager.shared.fetchCachedBooks(for: subject)

        if books.isEmpty {
            self.errorMessage = "No cached results available."
        }

        books.forEach { book in
            guard let key = book.key,
                  let title = book.title else { return }

            var bookItem = BookItem(key: key, title: title, coverId: Int(book.coverId))

            // Parse authors if stored as a comma-separated string
            let authors = book.authors?.split(separator: ",").map { Author(name: String($0).trimmingCharacters(in: .whitespaces)) }
            bookItem.authors = authors

            bookItems.append(bookItem)
        }
    }

    // MARK: - Reset State
    private func resetState() {
        bookItems = []
        currentPage = 0
        hasMorePages = true
        errorMessage = nil
    }

    // MARK: - Delete Expired Cache
    private func deleteExpiredCache() {
        PersistenceManager.shared.deleteExpiredCache()
    }
}
