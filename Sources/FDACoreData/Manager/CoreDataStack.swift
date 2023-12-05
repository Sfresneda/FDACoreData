import CoreData
import Foundation

/// CoreDataStack is a wrapper around NSPersistentContainer and NSManagedObjectContext
/// to make it easier to use CoreData.
final class CoreDataStack {

    // MARK: Properties
    private var container: NSPersistentContainer
    private(set) var context: NSManagedObjectContext

    // MARK: Lifecycle
    init(container: NSPersistentContainer) {
        self.container = container
        self.context = container.viewContext
    }
}

// MARK: - Public Methods
extension CoreDataStack {

    /// Loads the persistent stores for the container.
    /// - Returns: The CoreDataStack load description.
    @discardableResult
    func load() async throws -> CoreDataStack {
        try await withCheckedThrowingContinuation({ continuation in
            container.loadPersistentStores { (description, error) in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: self)
                }
            }
        })
    }

    /// Saves the context.
    func saveContext() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}

