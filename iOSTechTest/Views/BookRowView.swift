//
//  BookRowView.swift
//  iOSTechTest
//
//  Created by Marco Abundo on 1/12/25.
//

import SwiftUI

struct BookRowView: View {
    let bookItem: BookItem

    var body: some View {
        HStack {
            RowImageView(bookItem: bookItem)

            VStack(alignment: .leading) {
                Text(bookItem.title)
                Text(bookItem.authorsString)
                    .font(.caption)
            }
        }
    }
}

#Preview("BookRowView") {
    let author = Author(key: "/authors/OL21177A", name: "Emily Bronte")
    let bookItem = BookItem(key: "/works/OL21177W",
                            title: "Wuthering Heights",
                            authors: [author], coverId: nil)
    BookRowView(bookItem: bookItem)
}
