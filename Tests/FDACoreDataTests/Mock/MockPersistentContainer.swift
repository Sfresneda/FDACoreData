import CoreData
import Foundation

final class MockPersistentContainer: NSPersistentContainer {
    override class func defaultDirectoryURL() -> URL {
        return URL(fileURLWithPath: "/dev/null")
    }

    override init(name: String,
                  managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        persistentStoreDescriptions = [description]
    }
}
