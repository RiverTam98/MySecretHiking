
import XCTest
import Foundation

class SecretHikeSpotsXCUITestsBase: XCTestCase {

    var app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDownWithError() throws {
    }
    
}
