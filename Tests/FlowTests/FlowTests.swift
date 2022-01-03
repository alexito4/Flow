import Flow
import XCTest

final class FlowTests: XCTestCase {
    // MARK: Extensions

    func testThen() throws {
        let object = Object().then {
            $0.variable = 42
        }
        XCTAssertEqual(object.variable, 42)

        let fixValue = Value().then {
            $0.variable = 42
        }
        XCTAssertEqual(fixValue.variable, 42)
    }

    func testMutate() throws {
        var object = Object()
        object.mutate { // same as then
            $0.variable = 42
        }
        XCTAssertEqual(object.variable, 42)

        var value = Value()
        value.mutate {
            $0.variable = 42
        }
        XCTAssertEqual(value.variable, 42)
    }

    func testLet() throws {
        let onumber: Int = Object().let {
            $0.variable
        }
        XCTAssertEqual(onumber, 0)

        let vnumber: Int = Value().let {
            $0.variable
        }
        XCTAssertEqual(vnumber, 0)

        let kpnumber: Int = Value().let(\.variable)
        XCTAssertEqual(kpnumber, 0)
    }

    func testDo() throws {
        var oCalled = false
        Object().do {
            oCalled = true
            $0.doSomething()
        }
        XCTAssertEqual(oCalled, true)

        let vnumber: Int = Value().let {
            $0.variable
        }
        XCTAssertEqual(vnumber, 0)
    }
    
    func testDebug() {
        var printed: [String] = []
        let printer = {
            printed.append($0)
        }
        let number = 41
            .debug()
            .debug(printer: printer)
            .then {
                $0 += 1
            }
            .debug("after", printer: printer)
        XCTAssertEqual(number, 42)
        XCTAssertEqual(printed, ["41", "after: 42"])
    }

    // MARK: Free functions

    func testFreeWith() throws {
        let object = with(Object()) {
            $0.variable = 42
        }
        XCTAssertEqual(object.variable, 42)

        let fixValue = with(Value()) {
            $0.variable = 42
        }
        XCTAssertEqual(fixValue.variable, 42)
    }

    func testFreeLet() throws {
        let onumber: Int = withLet(Object()) {
            $0.variable = 42
            return 42
        }
        XCTAssertEqual(onumber, 42)

        let vnumber: Int = withLet(Value()) {
            $0.variable = 42
            return 42
        }
        XCTAssertEqual(vnumber, 42)
    }

    func testFreeDo() throws {
        let number: Int = Flow.run {
            let text = "hello world"
            return text.count
        }
        XCTAssertEqual(number, 11)

        var called = false
        Flow.run { // return void
            print("Do something")
            called = true
        }
        XCTAssertTrue(called)
    }

    // MARK: Conformances

    func testConformances() throws {
        XCTAssertTrue([Int]().let { _ in true })
        XCTAssertTrue([Int: Int]().let { _ in true })
        XCTAssertTrue(Set<Int>().let { _ in true })
        XCTAssertTrue(String().let { _ in true })
        XCTAssertTrue(Int().let { _ in true })
        XCTAssertTrue(Double().let { _ in true })
        XCTAssertTrue(Float().let { _ in true })
        XCTAssertTrue(NSObject().let { _ in true })
        XCTAssertTrue(Date().let { _ in true })
        XCTAssertTrue(CGPoint().let { _ in true })
        XCTAssertTrue(CGRect().let { _ in true })
        XCTAssertTrue(CGSize().let { _ in true })
        XCTAssertTrue(CGVector().let { _ in true })
    }
}

class Object: Flowable {
    let constant = 0
    var variable = 0
    func doSomething() {}
}

struct Value: Flowable {
    let constant = 0
    var variable = 0
    func doSomething() {}
}
