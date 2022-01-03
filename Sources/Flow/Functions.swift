/// Execute a closure with the given object.
///
/// This free function it's a substitute for `.then` when you can't use the method
/// or if you prefer the free function style.
/// ```
/// let label = with(UILabel()) {
///     $0.text = "Hello"
///     $0.textColor = .red
///     $0.font = .preferredFont(forTextStyle: .largeTitle)
///     $0.sizeToFit()
/// }
/// ```
/// Inspirations and Similar methods:
/// - [Overture.with](https://github.com/pointfreeco/swift-overture#with-and-update)
/// - [Kotlin.with](https://kotlinlang.org/docs/scope-functions.html#with)
/// - Many other languages have a `with` or `using` function.
/// - Note: This works for both reference and value types. Value types mutate and return a copy.
/// - Returns: The return of the closure.
@inlinable
public func with<T>(
    _ object: T,
    _ block: (inout T) throws -> Void
) rethrows -> T {
    var copy = object
    try block(&copy)
    return copy
}

/// Execute a closure with the given object letting you return a new object.
///
/// This free function it's a substitute for `.let` when you can't use the method
/// or if you prefer the free function style.
/// ```
/// let result = withLet(Object()) {
///     let something = ...
///     return something.convert($0)
/// }
/// ```
/// Inspirations and Similar methods:
/// - [Overture.with](https://github.com/pointfreeco/swift-overture#with-and-update)
/// - [Kotlin.with](https://kotlinlang.org/docs/scope-functions.html#with)
/// - Many other languages have a `with` or `using` function.
/// - Note: This works for both reference and value types. Value types mutate a copy.
/// - Note: This is the same as `with` but with a different return type. It makes it clearer to the compiler which otherwise gets too confused.
/// - Returns: The return of the closure which can be a different type.
@inlinable
public func withLet<T, R>(
    _ object: T,
    _ block: (inout T) throws -> R
) rethrows -> R {
    var copy = object
    return try block(&copy)
}

/// Execute a closure of statements as an expression.
///
/// This is like making a closure and invoking it immediatly:
/// ```
/// let result = { ... }()
/// ```
/// But with a named function:
/// ```
/// let result = run { ... }
/// ```
/// Inspirations and Similar methods:
/// - Swift's own immedaitly run closure pattern.
/// - [Kotlin.run](https://kotlinlang.org/docs/scope-functions.html#run)
/// - Returns: The return of the closure.
@inlinable
public func run<R>(
    _ block: () throws -> R
) rethrows -> R {
    try block()
}
