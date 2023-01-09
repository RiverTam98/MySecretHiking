
import Foundation
import XCTest

class HikingSpotTests: SecretHikeSpotsXCUITestsBase {
    
    func testCreateHikingSpot() {
        //This test allows users to create new spots by selecting a point on a map and giving it a name
        givenIHaveTheAppOpen()
        whenITapOnAddNewHikingSpotButton()
        andTheMapPageOpens()
        andIGiveLocationPermissionIfRequired()
        andIChooseALocation()
        andIClickOnSaveThisSpot()
        andINameMySpot()
        andIClickSave()
        thenIShouldHaveCreatedAHikingSpot()
    }
    
    func testScrollThroughAListOfHikingSpots(){
        //This test allows user to scroll through the list of hiking spots
        givenIHaveTheAppOpen()
        andICreateAnotherHikingSpot()
        andICreateAnotherHikingSpot()
        andICreateAnotherHikingSpot()
        andICreateAnotherHikingSpot()
        whenICreateAnotherHikingSpot()
        thenIshouldBeAbleToScrollThroughTheList()
                
        
    }
    
    func testDeleteHikingSpot() {
        //This test allows users to see their previously saved Spots in a list with the newest first
        //and to remove a Spot from their list
        givenIHaveAHikingSpotsSaved()
        andTheListIsShowingTheNewestFirst()
        whenISwipteToDelete()
        thenTheHikingSpotShouldBeDeleted()
        
    }
}

