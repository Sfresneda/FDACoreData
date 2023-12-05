
import CoreData
import XCTest
@testable import FDACoreData

final class CoreDataStackTests: XCTestCase {
    var sut: CoreDataStack!
    
    override func setUp() {
        let model = MockObjectModel()
        let container = MockPersistentContainer(name: Self.description(),
                                                managedObjectModel: model)
        
        sut = CoreDataStack(container: container)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_load_shouldReturnAnError() async {
        // When
        do {
            _ = try await sut.load()
            // Then
            
        } catch {
            XCTFail("unexpected error \(error)")
        }
    }
}
