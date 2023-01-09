
import Foundation
import XCTest

extension XCUIElement{

    func longSwipe() {
        let startOffset = CGVector(dx: 0.6, dy: 0.0)
        let endOffset = CGVector(dx: 0.0, dy: 0.0)
        let startPoint = self.coordinate(withNormalizedOffset: startOffset)
                let endPoint = self.coordinate(withNormalizedOffset: endOffset)
        startPoint.press(forDuration: 0, thenDragTo: endPoint)
    }
}
