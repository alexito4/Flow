# Flow

🌊 Let your code *flow*.

This library provides a bunch of extension methods for a better fluent syntax in Swift. This style is very useful for some operations that benefit from being able to be chained (composed) together.

## Functionality

- `.then` to configure reference and value types. Useful for configuration at the point of initialization.

- `.mutate` in place value types.
- `.let` to transform an object into another.
- `.do` to perform multiple actions with the same object.
- Free function variants, for when you prefer this syntax or don't want to conform to the protocol:
  - `with` (similar to `.then`)
  - `withLet` (similar to `.let`)
- `run` as an alternative to immediately executed closures.

## `.then`

Use `.then` to perform an object configuration inline. It applies statements in the closure to the object. It's very useful to set the properties of an object when defining it.

```swift
let label = UILabel().then {
  $0.text = "Hello"
  $0.textColor = .red
  $0.font = .preferredFont(forTextStyle: .largeTitle)
  $0.sizeToFit()
}

let size = CGSize().then {
	$0.width = 20
}
```

> There are two overloads of this method provided. One that works on `AnyObject` (a.k.a. classes) and another that operates on `Any` (intended for value types). The compiler picks the correct one appropriately.

- In the closure you get a reference to `self` or an `inout` copy in case of value types.
- It returns the same reference to the object, or the mutated copy for value types.

Influences:

- [Then.with](https://github.com/devxoul/Then/blob/master/Sources/Then/Then.swift#L42)
- [Kotlin.apply](https://kotlinlang.org/docs/scope-functions.html#apply) and [Kotlin.also](https://kotlinlang.org/docs/scope-functions.html#also)

## `.mutate`

Mutates a value **in place**. It s like `.then` but applies to `self` instead of a new copy. The value needs to be defined as a `var`.

```swift
view.frame.mutate {
  $0.origin.y = 200
  $0.size.width = 300
}
```

- In the closure you get an `inout` reference to `self` .
- It returns nothing.

> This should be used only for value types. For reference types is recommended to use `.then`.

## `.let`

You can think of `.let` as a `map` operation but for all the types (not only for *Functors*). It lets you transform the object into an object of another type.

```swift
let dateString: String = Date().let {
    let formatter = DateFormatter()
    return formatter.string(from: $0)
}
```

It works especially well for type conversions based on initializers:

```swift
let number: Int? = "42".let(Int.init)
```

> Don't overuse this when you can use just plain dot syntax. You can use it to access a member of the object `Date().let { $0.timeIntervalSince1970 }` but that's just the same as `Date().timeIntervalSince1970`. 

- You get a reference to `self` in the closure.
- It returns the object returned in the closure.

Influences:

- Swift's own `let` declaration.
- [Kotlin.let](https://kotlinlang.org/docs/scope-functions.html#let) and [Kotlin.run](https://kotlinlang.org/docs/scope-functions.html#run).

##  `.do`

Use this method to perform multiple actions (side effects) with the same object. It helps to reduce the verbosity of typing the same name multiple times.

```swift
UserDefaults.standard.do {
    $0.set(42, forKey: "number")
    $0.set("hello", forKey: "string")
    $0.set(true, forKey: "bool")
}
```

This behaves like other methods if you discard their return, but is preferred to use `do` to convey the intention better. It also lets you avoid writing the `return` on some occasions.

- You get a reference to `self` in the closure.
- It returns nothing.

Influences:

- [Then.do](https://github.com/devxoul/Then/blob/master/Sources/Then/Then.swift#L56)

## `.debug`

By default, it prints `self` to the console. This method is useful for debugging intermediate values of a chain of method calls.

```swift
let result = Object()
   .then { ... }
   .debug("prefix")
   .let { ... }
   .debug()
```

- You get a reference to `self` in the closure.
- It returns the same object without touching it.

## Free function `with`
Executes a closure with the object. This free function it's a substitute for `.then` when you can't use the method or if you prefer the free function style.

```swift
let label = with(UILabel()) {
    $0.text = "Hello"
    $0.textColor = .red
    $0.font = .preferredFont(forTextStyle: .largeTitle)
    $0.sizeToFit()
}
```

- You get a reference to an `inout` copy of `self` in the closure.
- It returns the returned object in the closure.

Influences:

- [Overture.with](https://github.com/pointfreeco/swift-overture#with-and-update)
- [Kotlin.with](https://kotlinlang.org/docs/scope-functions.html#with)
- Many other languages have a `with` or `using` function.

## Free function `withLet`
Variant of `with` that let's you return a different type. It's a free function alternative of `let`.

## Free function `run`
Executes a closure of statements, useful to be used when you need an expression. This is like making a closure and invoking immediately but sometimes is clearer to have a specific name for it.

```swift
let result = run { ... } // same as { ... }()
```

Influences:

- [Kotlin.run](https://kotlinlang.org/docs/scope-functions.html#run)


## Supported Types

Since Swift doesn't let us extend non-nominal types like `Any` we need to conform each type to the `Flowable` protocol. 

The library provides out of the box conformances for a bunch of Standard Library, Foundation and UIKit types. See [Conformances.swift](/Sources/Flow/Conformances.swift) for the entire list.

You can conform any type yourself by just extending it:

```swift
extension YourType: Flowable {}
```

> Note that you can use the free function variants without the types conforming to the protocol.

## Influences

- [devxoul/Then](https://github.com/devxoul/Then)
- Functional style approaches (like [Overture](https://github.com/pointfreeco/swift-overture))
- Kotlin [Scope Functions](https://kotlinlang.org/docs/scope-functions.html). Note that Swift can't "rebind self" inside a closure, so most of Kotlin's scope functions are redundant.
- Other languages that have a similar `with` or `using` functions.

# Author

Alejandro Martinez | http://alejandromp.com | [@alexito4](https://twitter.com/alexito4)
