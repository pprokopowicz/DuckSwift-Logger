import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DuckSwift_LoggerTests.allTests),
    ]
}
#endif
