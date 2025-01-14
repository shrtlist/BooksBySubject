//
//  BooksResponse.swift
//  iOSTechTest
//
//  Created by Marco Abundo on 1/11/25.
//

import Foundation

// Top-level response for the searchBooks endpoint
struct BooksResponse: Decodable {
    let works: [BookItem]
}
