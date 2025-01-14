//
//  NetworkingServiceProtocol.swift
//  iOSTechTest
//
//  Created by Marco Abundo on 1/13/25.
//

protocol NetworkingServiceProtocol: AnyObject {
    func searchBySubject(_ subject: String, page: Int, limit: Int) async throws -> [BookItem]
    func getBookInfo(bookItem: BookItem) async throws -> BookInfo
    func isConnectedToNetwork() -> Bool
}
