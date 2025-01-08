//
//  ContentView.swift
//  iOSTechTest
//
//  Created by Stone Zhang on 2023/11/26.
//

import SwiftUI

// MARK: - BookListView

struct BookListView: View {
    @State var searchText: String = ""
    @State var bookItems: [BookItem] = []
    @State private var navPath: [BookInfo] = []

    var body: some View {
        NavigationStack(path: $navPath) {
            List {
                ForEach(bookItems, id: \.key) { bookItem in
                    Button(
                        action: {
                            Task {
                                let bookInfo = await getBookInfo(bookItem: bookItem)
                                navPath.append(bookInfo)
                            }
                        },
                        label: {
                            HStack {
                                Image(systemName: "book.fill")
                                Text(bookItem.title)
                            }
                        }
                    )
                    .buttonStyle(.plain)
                }
            }
            .navigationDestination(for: BookInfo.self) { bookInfo in
                BookDetailView(bookInfo: bookInfo)
            }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search) {
            Task {
                bookItems = await searchBySubject(searchText)
            }
        }
    }
}

#Preview("BookListView") {
    let bookItems = [
        BookItem(key: "/works/OL21177W",
                 title: "Wuthering Heights",
                 imageURL: ""),
        BookItem(key: "/works/OL468431W",
                 title: "The Great Gatsby",
                 imageURL: ""),
        BookItem(key: "/works/OL98501W",
                 title: "Ethan Frome",
                 imageURL: "")
    ]
    return BookListView(bookItems: bookItems)
}

// MARK: - BookDetailView

struct BookDetailView: View {
    let bookInfo: BookInfo

    var body: some View {
        VStack {
            Image(systemName: "book.fill")
                .font(.system(size: 150))
            Text(bookInfo.title)
                .font(.largeTitle)
                .padding(16)
            Text(bookInfo.description)
                .padding(16)
        }
    }
}

#Preview("BookDetailView") {
    let bookInfo = BookInfo(key: "", 
                            title: "Hello World",
                            imageURL: "",
                            description: "Nothing to show")
    return BookDetailView(bookInfo: bookInfo)
}

// MARK: - Models

// TODO: Add authors information, at least the primary one
struct BookItem {
    let key: String
    let title: String
    let imageURL: String
}

struct BookInfo: Hashable {
    let key: String
    let title: String
    let imageURL: String
    let description: String
}

// MARK: - APIs

private func searchBySubject(_ subject: String) async -> [BookItem] {
    let url = URL(string: "https://openlibrary.org/subjects/love.json?limit=20")!
    let request = URLRequest(url: url)
    let (data, _) = try! await URLSession.shared.data(for: request)
    let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
    let works = json["works"] as! [[String: Any]]
    var bookItems = [BookItem]()
    for work in works {
        let bookItem = BookItem(key: work["key"] as! String,
                                title: work["title"] as! String,
                                imageURL: "")
        bookItems.append(bookItem)
    }
    return bookItems
}

private func getBookInfo(bookItem: BookItem) async -> BookInfo {
    let url = URL(string: "https://openlibrary.org/\(bookItem.key).json")!
    let request = URLRequest(url: url)
    let (data, _) = try! await URLSession.shared.data(for: request)
    let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
    let bookInfo = BookInfo(key: bookItem.key,
                            title: bookItem.title,
                            imageURL: bookItem.imageURL,
                            description: json["description"] as! String)
    return bookInfo
}
