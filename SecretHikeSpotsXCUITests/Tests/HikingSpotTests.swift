
import Foundation
import XCTest

class HikingSpotTests: SecretHikeSpotsXCUITestsBase {
    
    func testCreateHikingSpot() {
        //Users should be able to create new Spots by selecting a point on a map and giving it a name
        givenIHaveAppOpen()
        whenITapOnAddNewHikingSpotButton()
        andTheMapPageOpens()
        andIGiveLocationPermissionIfRequired()
        andIChooseALocation()
        andIClickOnSaveThisSpot()
        andINameMySpot()
        andIClickSave()
        thenIShouldHaveCreatedAHikingSpot()
    }
    
    func testDeleteHikingSpot() {
        //Users should be able to see their previously saved Spots in a list with the newest first
        //Users should be able to remove a Spot from their list
        givenIHaveHikingSpotsSaved()
        andTheListIsShowingTheNewestFirst()
        whenISwipteToDelete()
        thenTheHikingSpotShouldBeDeleted()
    }
}

