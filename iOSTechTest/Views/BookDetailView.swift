//
//  BookDetailView.swift
//  iOSTechTest
//
//  Created by Marco Abundo on 1/11/25.
//

import SwiftUI

struct BookDetailView: View {
    let bookInfo: BookInfo
    private let spacing: CGFloat = 16
    private let size: CGFloat = 150

    var body: some View {
        ScrollView {
            VStack(spacing: spacing) {
                if let url = bookInfo.coverURL {
                    AsyncCachedImage(url: url) { image in
                        image.resizable() // Displays the loaded image.
                            .scaledToFit()
                            .frame(width: size, height: size)
                    } placeholder: {
                        PlaceholderImageView(size: size)
                    }
                } else {
                    PlaceholderImageView(size: size)
                }
                Text(bookInfo.title)
                    .font(.largeTitle)
                Text(bookInfo.authorsString)
                Text("First published: \(bookInfo.firstPublishDate ?? "Unknown")")
                Text(bookInfo.description ?? "No description available")
            }
        }
    }
}

#Preview("BookDetailView") {
    let bookInfo = BookInfo(key: "/works/OL5294725W", title: "Hello World", description: "Nothing to show", firstPublishDate: "1983")
    BookDetailView(bookInfo: bookInfo)
}
