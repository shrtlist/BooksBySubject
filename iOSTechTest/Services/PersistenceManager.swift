//
//  PersistenceManager.swift
//  iOSTechTest
//
//  Created by Marco Abundo on 1/8/25.
//

import CoreData

final class PersistenceManager {
    static let shared = PersistenceManager()

    // MARK: - Core Data Stack

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Main") // Should match the Core Data model name
        container.loadPersistentStores { _, error in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Save Context

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save Core Data context: \(error)")
            }
        }
    }

    // MARK: - Save Books

    func saveBooks(_ books: [BookItem], subject: String) {
        let timestamp = Date()

        for bookItem in books {
            let book = Book(context: context)
            book.key = bookItem.key
            book.title = bookItem.title
            book.authors = bookItem.authorsString
            if let coverId = bookItem.coverId {
                book.coverId = Int32(coverId)
            }
            book.timestamp = timestamp
            book.subject = subject
        }

        saveContext()
    }

    func saveBookInfo(_ bookInfo: BookInfo) {
        guard let book = fetchBookDetails(bookId: bookInfo.key) else { return }
        book.bookDescription = bookInfo.description
        book.firstPublishDate = bookInfo.firstPublishDate

        saveContext()
    }

    // MARK: - Fetch Cached Books

    func fetchCachedBooks(for subject: String) -> [Book] {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        request.predicate = NSPredicate(format: "subject == %@", subject)

        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]

        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch books: \(error)")
            return []
        }
    }

    // MARK: - Fetch Book Details

    func fetchBookDetails(bookId: String) -> Book? {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        request.predicate = NSPredicate(format: "key == %@", bookId)

        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch book details: \(error)")
            return nil
        }
    }

    // MARK: - Delete Expired Cache

    func deleteExpiredCache() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Book.fetchRequest()
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        fetchRequest.predicate = NSPredicate(format: "timestamp < %@", weekAgo as NSDate)

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
            saveContext()
        } catch {
            print("Failed to delete expired cache: \(error)")
        }
    }

    func deleteAllCache() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Book.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            saveContext()
        } catch {
            print("Failed to delete all cache: \(error)")
        }
    }
}
