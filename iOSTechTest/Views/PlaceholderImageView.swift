//
//  PlaceholderImageView.swift
//  iOSTechTest
//
//  Created by Marco Abundo on 1/12/25.
//

import SwiftUI

struct PlaceholderImageView: View {
    var size = 40.0

    var body: some View {
        Image(systemName: "book.fill")
            .font(.system(size: size))
    }
}
