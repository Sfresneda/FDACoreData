# FDACoreData

FDACoreData is Swift 5.8 library for manage CoreData stack. It provides a simple way to create, save, fetch and delete data from CoreData.

## Installation
Add this SPM dependency to your project:
```
https://github.com/Sfresneda/FDACoreData
```

## Usage
Heres an example of how to use FDACoreData:

```swift
import FDACoreData

// Create a CoreData stack
let objectModel = ObjectModel()
let container = PersistentContainer(name: "MyAppContainer",
                                    managedObjectModel: objectModel)
let persistenceManager: FDACoreData<Model> = try await FDACoreData(container: container)
persistenceManager.load()

// Create a new object
let model: Model = try await persistenceManager.create()
model.name = "John"
model.age = 30

// Fetch objects
let models: [Model] = try await persistenceManager.fetch()

// Delete objects
try await persistenceManager.delete(models)

// Save changes
try await persistenceManager.save()
```

## License
This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details

## Author
Sergio Fresneda - [sfresneda](https://github.com/Sfresneda)
