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
    init(container: NSPersistentContainer) {
        dataStack = CoreDataStack(container: container)
    }
    
    /// Loads the persistent stores for the container.
    func load() async throws -> Self {
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
    /// - Parameters:
    ///  - limit: The maximum number of objects to fetch.
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
    func delete(_ object: NSManagedObject) {
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
