//
//  NetworkingService.swift
//  iOSTechTest
//
//  Created by Marco Abundo on 1/8/25.
//

import Foundation

final class NetworkingService {
    // Shared singleton instance for convenience
    static let shared = NetworkingService()

    private init() {}

    // MARK: - APIs

    /// Fetch books for a given subject with pagination
    func searchBySubject(_ subject: String, page: Int, limit: Int = 20) async throws -> [BookItem] {
        let urlString = "https://openlibrary.org/subjects/\(subject).json?limit=\(limit)&offset=\(page * limit)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let decodedResponse = try decoder.decode(BooksResponse.self, from: data)
            return decodedResponse.works
        } catch {
            throw URLError(.cannotDecodeContentData)
        }
    }

    /// Fetch details for a specific book using its OpenLibrary key
    func getBookInfo(bookItem: BookItem) async throws -> BookInfo {
        let urlString = "https://openlibrary.org/\(bookItem.key).json"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            var decodedResponse = try decoder.decode(BookInfo.self, from: data)

            // Propagate these properties to the decoded response
            decodedResponse.authors = bookItem.authors
            decodedResponse.coverId = bookItem.coverId
            return decodedResponse
        } catch {
            throw URLError(.cannotDecodeContentData)
        }
    }
}
