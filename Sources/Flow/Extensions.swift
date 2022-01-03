public extension Flowable where Self: Any {
    /// Apply the closure to `self`.
    ///
    /// It allows you to mutate a copy of the value.
    /// Useful to configure a value inline with its creation.
    /// ```
    /// let size = CGSize().then {
    ///     $0.width = 42
    ///     $0.mutatingMethod()
    /// }
    /// ```
    ///
    /// Inspirations and Similar methods:
    /// - [Then.with](https://github.com/devxoul/Then/blob/master/Sources/Then/Then.swift#L42)
    /// - [Kotlin.apply](https://kotlinlang.org/docs/scope-functions.html#apply)
    /// - [Kotlin.also](https://kotlinlang.org/docs/scope-functions.html#also)
    /// - Returns: The copy of self mutated in the closure.
    /// - Note: This overload applies to **Value Types**.
    @inlinable
    func then(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }

    /// Mutate a value in place.
    ///
    /// This is similar to `then` but for values types it applies to changes
    /// to the vale directly instead of to a copy.
    /// ```
    /// view.frame.mutate {
    ///     $0.origin.y = 200
    ///     $0.size.width = 300
    ///     $0.mutatingMethod()
    /// }
    /// ```
    ///
    /// - Returns: Nothing, it applies the changes in place.
    /// - Note: This should only be used with **Value types**.
    /// - Note: For references types this is the same as `then`.
    @inlinable
    mutating func mutate(_ block: (inout Self) throws -> Void) rethrows {
        try block(&self)
    }

    /// Transform the object into a new type.
    ///
    /// This is similar to `map` but for any object. It let's you transform the
    /// object into a new one of any type.
    /// ```
    /// let dateString: String = Date().let {
    ///     let formatter = DateFormatter()
    ///     return formatter.string(from: $0)
    /// }
    /// ```
    /// It works specially well for type conversesions based on initializers:
    /// ```
    /// let number: Int? = "42".let(Int.init)
    /// ```
    /// Don't overuse this when you can use just plain dot syntax.
    /// You can use it to access a member of the object Date().let { $0.timeIntervalSince1970 } but that's just the same as Date().timeIntervalSince1970.
    ///
    /// Inspirations and Similar methods:
    /// - Swift's own `let` declaration.
    /// - [Kotlin.let](https://kotlinlang.org/docs/scope-functions.html#let)
    /// - [Kotlin.run](https://kotlinlang.org/docs/scope-functions.html#run)
    ///
    /// - Returns: The return of the closure.
    @inlinable
    func `let`<R>(_ block: (Self) throws -> R) rethrows -> R {
        try block(self)
    }

    /// Makes the object availalbe to the closure.
    ///
    /// Useful to perform multiple actions (side effects) with the same object.
    /// It helps to avoid the verbosity of typing the name of the object
    /// multiple times. Instead you use `$0` which is shorter.
    ///
    /// ```
    /// UserDefaults.standard.do {
    ///     $0.set(42, forKey: "number")
    ///     $0.set("hello", forKey: "string")
    ///     $0.set(true, forKey: "bool")
    /// }
    /// ```
    /// Use this when you just want to perform actions without having any
    /// returned object. Using this method allows you to avoid the `return`.
    ///
    /// Inspirations and Similar methods:
    /// - [Then.do](https://github.com/devxoul/Then/blob/master/Sources/Then/Then.swift#L56)
    ///
    /// - Returns: Nothing, it just runs the closure.
    /// - Note: This is similar to `mutate` for reference types or `then` and discarding the value.
    @inlinable
    func `do`(_ block: (Self) throws -> Void) rethrows {
        try block(self)
    }
    
    /// Prints `self`.
    ///
    /// This method is useful to debug intermediate values of a chain of method calls.
    /// ```
    /// let result = Object()
    ///     .then { ... }
    ///     .debug("prefix")
    ///     .let { ... }
    ///     .debug()
    /// ```
    /// Since it returns self you can keep chaining other method calls.
    ///
    /// - Parameter prefix: String to prefix the print. `nil` by default.
    /// - Parameter printer: Inject a custom print function. Mostly for testing purposes. Uses `Swift.print()` by default.
    /// - Returns: The same object that it was called on (`self`).
    @inlinable
    func debug(
        _ prefix: String? = nil,
        printer: @escaping (String) -> Void = { Swift.print($0) }
    ) -> Self {
        if let prefix = prefix {
            printer("\(prefix): \(self)")
        } else {
            printer("\(self)")
        }
        return self
    }
}

public extension Flowable where Self: AnyObject {
    /// Apply the closure to `self`.
    ///
    /// It allows you to configure the object.
    /// Useful to configure an object inline with its creation.
    /// ```
    /// let label = UILabel().then {
    ///     $0.text = "Hello"
    ///     $0.textColor = .red
    ///     $0.font = .preferredFont(forTextStyle: .largeTitle)
    ///     $0.sizeToFit()
    /// }
    /// ```
    ///
    /// Inspirations and Similar methods:
    /// - [Then.then](https://github.com/devxoul/Then/blob/master/Sources/Then/Then.swift#L72)
    /// - [Kotlin.apply](https://kotlinlang.org/docs/scope-functions.html#apply)
    /// - [Kotlin.also](https://kotlinlang.org/docs/scope-functions.html#also)
    /// - Returns: The object after the closure has been applied.
    /// - Note: This overload applies to **Reference Types**.
    /// - Note: It has `@discardableResult` because with reference tyeps you can use this to configure in place.
    @inlinable
    @discardableResult
    func then(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}
