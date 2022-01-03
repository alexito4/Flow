/// A marker protocol.
///
/// Conforming to this protocol grants all the functionality of the library to that type.
/// Swift doesn't provide functionality to extend Any, so we need this protocol
/// and manual conformances.
/// See `Conformances.swift` for a list of provided conformances.
///
public protocol Flowable {}
