
import Foundation
import XCTest

class Screen {
    
    internal static var textFields = {XCUIApplication().textFields
    }()
    
    internal static var staticTexts = {XCUIApplication().staticTexts
    }()
    
    internal static var buttons = {XCUIApplication().buttons
    }()
    
    internal static var navigationBars = {XCUIApplication().navigationBars
    }()
    
    internal static var alerts = {XCUIApplication().alerts
    }()
    
    internal static var cells = {XCUIApplication().cells
    }()
    
}

