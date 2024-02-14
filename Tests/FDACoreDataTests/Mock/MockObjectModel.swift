import Foundation
import CoreData

final class MockObjectModel: NSManagedObjectModel {
    override init() {
        super.init()

        // Create the entity description
        let objectEntity = NSEntityDescription()
        objectEntity.name = "MockObject"
        objectEntity.managedObjectClassName = NSStringFromClass(MockObject.self)

        // Create the attributes for the entity
        let fooAttribute = NSAttributeDescription()
        fooAttribute.name = "foo"
        fooAttribute.attributeType = .stringAttributeType
        fooAttribute.isOptional = true

        let barAttribute = NSAttributeDescription()
        barAttribute.name = "bar"
        barAttribute.attributeType = .stringAttributeType
        barAttribute.isOptional = true

        // Add attributes to the entity
        objectEntity.properties = [fooAttribute, barAttribute]

        // Set the entities for the model
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
