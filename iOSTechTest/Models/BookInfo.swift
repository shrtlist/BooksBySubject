//
//  BookInfo.swift
//  iOSTechTest
//
//  Created by Stone Zhang on 2023/11/26.
//  Modified by Marco Abundo on 1/11/25.
//

import Foundation

// Detailed book response
struct BookInfo: Decodable, Hashable {
    let key: String
    let title: String
    var authors: [Author]?
    var coverId: Int?
    var description: String?
    var firstPublishDate: String?

    var authorsString: String {
        guard let authors = authors else {
            return "Author unknown"
        }

        return authors.map { $0.name ?? "" }.joined(separator: ", ")
    }

    // Generate the full cover URL if a coverId is available
    var coverURL: URL? {
        guard let coverId = coverId else { return nil }
        return URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-L.jpg")
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}
