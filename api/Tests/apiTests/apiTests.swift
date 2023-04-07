import XCTest
@testable import api

final class apiTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(api().text, "Hello, World!")
    }
}
