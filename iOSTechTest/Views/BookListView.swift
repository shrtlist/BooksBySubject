//
//  BookListView.swift
//  iOSTechTest
//
//  Created by Stone Zhang on 2023/11/26.
//

import SwiftUI

// MARK: - BookListView

struct BookListView: View {
    @StateObject private var viewModel = BookListViewModel()
    @State private var searchText: String = ""
    @State private var navPath: [BookInfo] = []

    var body: some View {
        NavigationStack(path: $navPath) {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if viewModel.bookItems.isEmpty {
                    ScrollView {
                        ContentUnavailableView.init("No results", systemImage: "book.fill")
                    }
                } else {
                    List(viewModel.bookItems, id: \.key) { bookItem in
                        Button(
                            action: {
                                Task {
                                    if let bookInfo = await viewModel.fetchBookDetails(bookItem: bookItem) {
                                        navPath.append(bookInfo)
                                    }
                                }
                            },
                            label: {
                                BookRowView(bookItem: bookItem)
                            }
                        )
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Books by Subject")
            .navigationDestination(for: BookInfo.self) { bookInfo in
                BookDetailView(bookInfo: bookInfo)
            }
            .searchable(text: $searchText)
            .searchPresentationToolbarBehavior(.avoidHidingContent)
            .textInputAutocapitalization(.never)
            .onSubmit(of: .search) {
                Task {
                    await viewModel.searchBooks(for: searchText)
                }
            }
        }
    }
}
