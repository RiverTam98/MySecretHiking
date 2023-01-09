
import Foundation
import XCTest

class HomeScreen: Screen {
    
    static let diamondActionButton: XCUIElement = buttons["plus.diamond.fill, Add new secret hiking spot"]
    static let myHikingSpotsHeader: XCUIElement = staticTexts["My Hiking spots"]
    static let saveHikingSpotCellsGlasvegas: XCUIElement = cells["Near Glasvegas, Map pin, Legal"]
    static let saveHikingSpotCellsEdinburgh: XCUIElement = cells["Edinburgh, Map pin, Legal"]
    static let saveHikingSpotCellsTopSpot: XCUIElement = cells["Top Spot, Map pin, Legal"]
    static let deleteHikingSpotButton: XCUIElement = buttons["Delete"]
    
}
