import Foundation

/// Errors that can be thrown by the DataManager.
public enum DataManagerError: Error {

    /// The entity was not found.
    case entityNotFound

    /// There was an error fetching the data.
    case fetchError(description: String)
}
