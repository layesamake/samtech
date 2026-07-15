import Flutter
import UIKit
import XCTest

class RunnerTests: XCTestCase {

  func testRunnerBundleIdentifier() {
    XCTAssertEqual(Bundle.main.bundleIdentifier, "com.samtech.crm")
  }

}
