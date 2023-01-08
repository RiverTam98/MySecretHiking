
import Foundation
import XCTest

class HikingSpotTests: SecretHikeSpotsXCUITestsBase {
    
    func testCreateHikingSpot() {
        //This test allows users should to create new Spots by selecting a point on a map and giving it a name
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
        //This test allows users to see their previously saved Spots in a list with the newest first
        //and to remove a Spot from their list
        givenIHaveHikingSpotsSaved()
        andTheListIsShowingTheNewestFirst()
        whenISwipteToDelete()
        thenTheHikingSpotShouldBeDeleted()
        
    }
}

