
import Foundation
import XCTest

class AddCurrentLocationDialogScreen: Screen {
    
    static let addCurrentLocationDialogHeader: XCUIElement = staticTexts["That spot looks nice ! Give it a name"]
    static let addCurrentLocationDialogTextField: XCUIElement = textFields["Camping in the woods"]
    static let addCurrentLocationDialogSaveButton: XCUIElement = buttons["Save"]
    
}
