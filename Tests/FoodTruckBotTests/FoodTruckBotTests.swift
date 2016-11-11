import XCTest
@testable import FoodTruckBot

class FoodTruckBotTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(FoodTruckBot().text, "Hello, World!")
    }


    static var allTests : [(String, (FoodTruckBotTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
