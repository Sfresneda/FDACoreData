import Foundation
import CoreData

final class MockObjectModel: NSManagedObjectModel {
    override init() {
        super.init()

        let objectEntity = NSEntityDescription()
        objectEntity.name = "MockObject"
        objectEntity.managedObjectClassName = NSStringFromClass(MockObject.self)
        
        self.entities = [objectEntity]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MockObject: NSManagedObject {
    @NSManaged var foo: String?
    @NSManaged var bar: String?
}
