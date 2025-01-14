//
//  RowImageView.swift
//  iOSTechTest
//
//  Created by Marco Abundo on 1/12/25.
//

import SwiftUI

struct RowImageView: View {
    let bookItem: BookItem
    private let cornerRadius = 5.0
    private let width = 40.0
    private let height = 50.0
    private let size = 30.0

    var body: some View {
        if let url = bookItem.coverURL {
            AsyncCachedImage(url: url) { image in
                image
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .cornerRadius(cornerRadius)
            } placeholder: {
                Image(systemName: "book.fill")
                    .imageScale(.small)
            }
        } else {
            PlaceholderImageView(size: size)
        }
    }
}
