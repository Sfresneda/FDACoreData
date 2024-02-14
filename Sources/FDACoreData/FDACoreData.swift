import CoreData
import Foundation

/// FDACoreData is a wrapper around CoreDataStack. It provides a set of methods to
/// create, fetch, delete and save NSManagedObject. It also provides a load method
/// to load the persistent stores for the container. It is an async/await version
/// of CoreDataStack.
public actor FDACoreData<O: NSManagedObject> {

    // MARK: Properties
    private let dataStack: CoreDataStack
    
    // MARK: Lifecycle
    public init(container: NSPersistentContainer) {
        dataStack = CoreDataStack(container: container)
    }
    
    /// Loads the persistent stores for the container.
    public func load() async throws -> Self {
        _ = try await dataStack.load()
        return self
    }
}

// MARK: - Public Methods
public extension FDACoreData {

    /// Creates a new NSManagedObject.
    func create() throws -> O {
        let name = "\(O.self)"
        
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: dataStack.context) else {
            throw DataManagerError.entityNotFound
        }
        
        let model = O(entity: entity, insertInto: dataStack.context)
        
        return model
    }

    /// Fetches NSManagedObject, optionally filtered by a search predicate.
    /// The update operation will be saved to the context once the block is executed.
    /// - Parameters:
    /// - search: The predicate that specifies the filter criteria.
    /// - sort: The sort descriptors to use to order the fetched objects.
    /// - block: The block to execute the update for the fetched object.
    func update(_ predicate: NSPredicate,
                sort: [NSSortDescriptor]? = nil,
                block: ((O) -> Void)) throws {
        guard let objectToUpdate = try fetch(limit: 1,
                                             search: predicate,
                                             sort: sort).first else {
            throw DataManagerError.entityNotFound
        }

        block(objectToUpdate)

        try save()
    }

    /// Fetches NSManagedObject, optionally filtered by a search predicate.
    /// - Parameters:
    /// - limit: The maximum number of objects to fetch.
    /// - search: The predicate that specifies the filter criteria.
    /// - sort: The sort descriptors to use to order the fetched objects.
    /// - Returns: An array of NSManagedObject.
    func fetch(limit: Int = 0,
               search: NSPredicate? = nil,
               sort: [NSSortDescriptor]? = nil) throws -> [O] {
        let fetchRequest = O.fetchRequest()
        fetchRequest.fetchLimit = limit
        fetchRequest.predicate = search
        fetchRequest.sortDescriptors = sort
        
        do {
            let result = try dataStack.context.fetch(fetchRequest)
            return (result as? [O]) ?? []
            
        } catch {
            throw DataManagerError.fetchError(description: error.localizedDescription)
        }
    }
    
    /// Deletes a concrete NSManagedObject.
    /// - Parameter object: The NSManagedObject to delete.
    func delete(_ object: O) {
        dataStack.context.delete(object)
    }
    
    /// Deletes NSManagedObject matching the search predicate.
    /// - Parameter search: The predicate that specifies the filter criteria.
    func delete(search: NSPredicate? = nil) {
        let results: [O]? = try? fetch(search: search)
        
        results?.forEach { object in
            delete(object)
        }
    }
    
    /// Saves the context.
    func save() throws {
        try dataStack.saveContext()
    }
}
