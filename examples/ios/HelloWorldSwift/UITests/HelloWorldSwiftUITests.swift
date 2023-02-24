import XCTest

final class HelloWorldSwiftUITests: XCTestCase {

    func testLaunch() throws {
        print("Env: \(ProcessInfo().environment)")
        let app = XCUIApplication(bundleIdentifier: "com.example.hello-world-swift")
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))
        XCTAssertTrue(app.staticTexts["Hello World"].waitForExistence(timeout: 60))
    }
}