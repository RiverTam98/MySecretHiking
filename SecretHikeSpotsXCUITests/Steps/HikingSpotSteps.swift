
import Foundation
import XCTest

extension SecretHikeSpotsXCUITestsBase {
    
    func givenIHaveTheAppOpen(){
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
        HomeScreen.saveHikingSpotCellsGlasvegas.waitForExistence(timeout: 10)
    }
    
    func andICreateAnotherHikingSpot(){
        HomeScreen.myHikingSpotsHeader.waitForExistence(timeout: 10)
        HomeScreen.diamondActionButton.tap()
        MapViewScreen.saveThisSpotButton.waitForExistence(timeout: 2)
        app.tap()
        app.coordinate(withNormalizedOffset: CGVector(dx: 100, dy: 222)).tap()
        MapViewScreen.saveThisSpotButton.tap()
        AddCurrentLocationDialogScreen.addCurrentLocationDialogTextField.typeText(randomString(length: 6))
        AddCurrentLocationDialogScreen.addCurrentLocationDialogSaveButton.tap()
        HomeScreen.myHikingSpotsHeader.waitForExistence(timeout: 10)
    }
    
    func whenICreateAnotherHikingSpot(){
        HomeScreen.myHikingSpotsHeader.waitForExistence(timeout: 10)
        HomeScreen.diamondActionButton.tap()
        MapViewScreen.saveThisSpotButton.waitForExistence(timeout: 2)
        app.tap()
        app.coordinate(withNormalizedOffset: CGVector(dx: 100, dy: 222)).tap()
        MapViewScreen.saveThisSpotButton.tap()
        AddCurrentLocationDialogScreen.addCurrentLocationDialogTextField.typeText("Top Spot")
        AddCurrentLocationDialogScreen.addCurrentLocationDialogSaveButton.tap()
        HomeScreen.myHikingSpotsHeader.waitForExistence(timeout: 10)
    }
    
    func thenIshouldBeAbleToScrollThroughTheList(){
        HomeScreen.saveHikingSpotCellsTopSpot.waitForExistence(timeout: 10)
        HomeScreen.saveHikingSpotCellsTopSpot.swipeUp()
        HomeScreen.saveHikingSpotCellsGlasvegas.waitForExistence(timeout: 10)
    }

    func givenIHaveAHikingSpotsSaved(){
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
        MapViewScreen.saveThisSpotButton.waitForExistence(timeout: 2)
        app.coordinate(withNormalizedOffset: CGVector(dx: 100, dy: 222)).tap()
        MapViewScreen.saveThisSpotButton.waitForExistence(timeout: 2)
        MapViewScreen.saveThisSpotButton.tap()
        XCTAssertTrue(AddCurrentLocationDialogScreen.addCurrentLocationDialogHeader.exists)
        AddCurrentLocationDialogScreen.addCurrentLocationDialogTextField.typeText("Edinburgh")
        AddCurrentLocationDialogScreen.addCurrentLocationDialogSaveButton.tap()
    }
    
    func andTheListIsShowingTheNewestFirst(){
        HomeScreen.saveHikingSpotCellsEdinburgh.waitForExistence(timeout: 10)
    }
    
    func whenISwipteToDelete(){
        HomeScreen.saveHikingSpotCellsEdinburgh.longSwipe()
        HomeScreen.deleteHikingSpotButton.tap()
    }
    
    func thenTheHikingSpotShouldBeDeleted(){
        XCTAssertFalse(HomeScreen.saveHikingSpotCellsGlasvegas.exists)
    }
}

