import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(loading_indicator_layerTests.allTests),
    ]
}
#endif
