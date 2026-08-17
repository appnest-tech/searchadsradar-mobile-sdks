import XCTest
@testable import searchadsradar

final class NormalizationTests: XCTestCase {
    func testBooleanSurvivesAsBool() {
        let out = SearchadsradarPlugin.normalized(NSNumber(value: true))
        XCTAssertTrue(out is Bool)
        XCTAssertEqual(out as? Bool, true)
    }

    func testIntStaysInt() {
        let out = SearchadsradarPlugin.normalized(NSNumber(value: 42))
        XCTAssertTrue(out is Int)
        XCTAssertEqual(out as? Int, 42)
    }

    func testDoubleStaysDouble() {
        let out = SearchadsradarPlugin.normalized(NSNumber(value: 1.5))
        XCTAssertTrue(out is Double)
        XCTAssertEqual(out as? Double, 1.5)
    }

    func testStringPassesThrough() {
        XCTAssertEqual(SearchadsradarPlugin.normalized("x") as? String, "x")
    }
}
