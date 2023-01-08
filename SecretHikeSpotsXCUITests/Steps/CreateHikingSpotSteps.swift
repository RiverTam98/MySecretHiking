
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
    
    func ThenIShouldHaveCreatedAHikingSpot(){
        
        HomeScreen.saveHikingSpotCells.waitForExistence(timeout: 10)
    }

        
}

