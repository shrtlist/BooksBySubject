//
//  Author.swift
//  iOSTechTest
//
//  Created by Marco Abundo on 1/11/25.
//

import Foundation

// Represents an author in the searchBooks response
struct Author: Decodable, Equatable {
    var key: String?
    var name: String?
}
