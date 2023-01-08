
import Foundation
import XCTest

extension SecretHikeSpotsXCUITestsBase {
    
    func givenIHaveAppOpen(){
        HomeScreen.myHikingSpotsHeader.waitForExistence(timeout: 10)
        XCTAssertTrue(HomeScreen.myHikingSpotsHeader.exists)
    }
    
    func whenITapOnAddNewHikingSpotButton(){
        XCTAssertTrue(HomeScreen.diamondActionButton.exists)
        HomeScreen.diamondActionButton.tap()
        
    }
    
    func andTheMapPageOpens(){
        MapViewScreen.mapViewCloseButton.waitForExistence(timeout: 10)
        XCTAssertTrue(MapViewScreen.mapViewCloseButton.exists)
    }
    
    func andIGiveLocationPermissionIfRequired(){
        addUIInterruptionMonitor(withDescription: "Allow “SecretHikeSpots” to use your location?") { (alert) -> Bool in
            if LocationPermissionDialogScreen.locationPermissionDialogHeading.exists {
                LocationPermissionDialogScreen.locationPermissionDialogAllowOnceButton.tap()
                return true
            }
            return false
        }
        app.tap()
    }
    
    func andIChooseALocation(){
        app.coordinate(withNormalizedOffset: CGVector(dx: 100, dy: 200)).tap()
    }
    
    func andIClickOnSaveThisSpot(){
        MapViewScreen.saveThisSpotButton.tap()
    }
    
    func andINameMySpot(){
        XCTAssertTrue(AddCurrentLocationDialogScreen.addCurrentLocationDialogHeader.exists)
        AddCurrentLocationDialogScreen.addCurrentLocationDialogTextField.typeText("Near Glasvegas")
    }
    
    func andIClickSave(){
        AddCurrentLocationDialogScreen.addCurrentLocationDialogSaveButton.tap()
    }
    
    func thenIShouldHaveCreatedAHikingSpot(){
        HomeScreen.saveHikingSpotCells.waitForExistence(timeout: 10)
    }

    func givenIHaveHikingSpotsSaved(){
        HomeScreen.myHikingSpotsHeader.waitForExistence(timeout: 10)
        HomeScreen.diamondActionButton.tap()
        addUIInterruptionMonitor(withDescription: "Allow “SecretHikeSpots” to use your location?") { (alert) -> Bool in
            if LocationPermissionDialogScreen.locationPermissionDialogHeading.exists {
                LocationPermissionDialogScreen.locationPermissionDialogAllowOnceButton.tap()
                return true
            }
            return false
        }
        app.tap()
        
        app.coordinate(withNormalizedOffset: CGVector(dx: 100, dy: 222)).tap()
        MapViewScreen.saveThisSpotButton.waitForExistence(timeout: 2)
        MapViewScreen.saveThisSpotButton.tap()
        XCTAssertTrue(AddCurrentLocationDialogScreen.addCurrentLocationDialogHeader.exists)
        AddCurrentLocationDialogScreen.addCurrentLocationDialogTextField.typeText("Edinburgh")
        AddCurrentLocationDialogScreen.addCurrentLocationDialogSaveButton.tap()
    }
    
    func andTheListIsShowingTheNewestFirst(){
        //assert table list location? tablesQuery
        HomeScreen.saveHikingSpotCells.waitForExistence(timeout: 10)
    }
    
    func whenISwipteToDelete(){
        //app.tables.containing(.cell, identifier:"Near Glasvegas, Map pin, Legal").element.swipeLeft()
        //tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells[\"Near Glasvegas, Legal\"].buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func thenTheHikingSpotShouldBeDeleted(){
     
        //another kind of assert table list location? tablesQuery
    }
    
    //can use other apps?
    //tablesQuery.cells["Near Glasvegas, Map pin, Legal"].children(matching: .other).element(boundBy: 0).tap()
    //        app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.statusBars.buttons["breadcrumb"]/*[[".windows[\"SBSwitcherWindow\"]",".otherElements[\"AppSwitcherContentView\"]",".otherElements[\"Maps\"].scrollViews.otherElements.statusBars",".buttons[\"Return to SecretHikeSpots\"]",".buttons[\"breadcrumb\"]",".otherElements[\"card:com.apple.Maps:sceneID:com.apple.Maps-5DF58A93-8C27-4BB4-8E21-60D6F1CCC4FB\"].scrollViews.otherElements.statusBars",".scrollViews.otherElements.statusBars"],[[[-1,6,3],[-1,5,3],[-1,2,3],[-1,1,2],[-1,0,1]],[[-1,6,3],[-1,5,3],[-1,2,3],[-1,1,2]],[[-1,6,3],[-1,5,3],[-1,2,3]],[[-1,4],[-1,3]]],[0,0]]@END_MENU_TOKEN@*/.tap()
}

