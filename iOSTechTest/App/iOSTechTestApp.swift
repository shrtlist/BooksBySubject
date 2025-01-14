//
//  iOSTechTestApp.swift
//  iOSTechTest
//
//  Created by Stone Zhang on 2023/11/26.
//

import SwiftUI

@main
struct iOSTechTestApp: App {
    let persistanceManager = PersistenceManager.shared

    var body: some Scene {
        WindowGroup {
            BookListView()
                .environment(\.managedObjectContext, persistanceManager.context)
        }
    }
}
