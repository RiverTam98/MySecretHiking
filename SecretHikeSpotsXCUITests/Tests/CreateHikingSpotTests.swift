
import Foundation
import XCTest

class CreateHikingSpotTests: SecretHikeSpotsXCUITestsBase {
    
    func testCreateHikingSpot() {
        givenIHaveAppOpen()
        whenITapOnAddNewHikingSpotButton()
        andTheMapPageOpens()
        andIGiveLocationPermissionIfRequired()
        andIChooseALocation()
        andIClickOnSaveThisSpot()
        andINameMySpot()
        andIClickSave()
        ThenIShouldHaveCreatedAHikingSpot()
    }
}

