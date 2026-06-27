import XCTest
@testable import RadioControllerLauncher

final class ControllerTargetTests: XCTestCase {
    func testTargetsAreUnique() {
        XCTAssertEqual(Set(ControllerTarget.all.map(\.id)).count, 3)
        XCTAssertEqual(Set(ControllerTarget.all.map(\.appName)).count, 3)
    }

    func testApplicationsPathIsFirstCandidate() {
        for target in ControllerTarget.all {
            XCTAssertEqual(target.candidatePaths(homeDirectory: "/Users/test").first,
                           "/Applications/\(target.appName).app")
        }
    }

    func testExpectedApplicationsAreRegistered() {
        XCTAssertEqual(ControllerTarget.all.map(\.appName),
                       ["KX3Controller", "FT817Controller", "FT857897Controller"])
    }
}
