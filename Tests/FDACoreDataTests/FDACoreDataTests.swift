import CoreData
import XCTest
@testable import FDACoreData

final class FDACoreDataTests: XCTestCase {
    var sut: FDACoreData<MockObject>!

    override func setUp() async throws {
        let model = MockObjectModel()
        let container = MockPersistentContainer(name: Self.description(),
                                                managedObjectModel: model)

        sut = try await FDACoreData(container: container)
        .load()
    }

    override func tearDown() {
        sut = nil
    }

    func test_create_shouldSucceed() async throws {
        // When
        do {
            let _: MockObject = try await sut.create()
            // Then
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_fetch_shouldBeEmpty() async throws {
        // When
        do {
            let objects: [MockObject] = try await sut.fetch()
            // Then
            XCTAssertTrue(objects.isEmpty)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_delete_oneItemShouldSucceed() async throws {
        //When
        do {
            let _: MockObject = try await sut.create()
            let itemToRemove: MockObject = try await sut.create()

            let result1: [MockObject] = try await sut.fetch()
            
            try await sut.delete(itemToRemove)
            let result2: [MockObject] = try await sut.fetch()
            
            // Then
            XCTAssertLessThan(result2.count, result1.count)

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    func test_delete_allItemsShouldSucceed() async throws {
        //When
        do {
            let _: MockObject = try await sut.create()
            let _: MockObject = try await sut.create()
            try await sut.delete()
            let result: [MockObject] = try await sut.fetch()

            // Then
            XCTAssertTrue(result.isEmpty)

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

}
