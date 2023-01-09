# job-challenge-auto-tester-iOS

This repository hosts the challenge for Gail Phillips applying for the Automated Tester - iOS role.  

## Tests at different levels 

    Create a hiking spot - can be automated as this feature is within the app and has a clear user journey and can be performed repeatedly. 
    Delete a hiking spot - this can be automated too as it can be included in the UI tests for hiking spot creation. I would suggest this is also manually tested occasionally too (maybe as new O/S's are released) as it is a very specific swipe action animation. 
    Scroll through the list of hiking spots - this can be automated too as it can be included in the UI tests for hiking spot creation. I would suggest this is also manually tested occasionally too as it is good to have a visual check of this feature or screenshot automation could be implemented. 
    Integration with other navigation apps to navigate to the spot. - I would suggest manually testing this feature to validate how the tool is working in conjunction with the rest of the application workflow, writing tests that integrate with third parties may not be stable or give much return on investment. 
  

## UI tests

### I have written tests for the user flows in the BDD format as this tends to be a format and framework which lends itself to easy reading, simple documentation, more uptake from other team members and easier handover to other QA colleagues if required.  


## Bugs improvements etc 

### While testing the app I have found some issues such as: 
    several different accessibility issues but the one which I had to fix to save my eyesight was the word SAVE on the location name dialog box. I resolved this by changing the word SAVE to blue and the word CANCEL to red as it is a destructive action. 

## 5 tests which I consider should be automated as UI tests and run before every release. Justifing my decision.

### 1 @ios @android @smoke
      Scenario: Login as Premium user

      When User logs in to the app with valid Premium credentials
      Then He should get an access to the app

### 2 @ios @android @smoke
      Scenario: Like the tour

      When User taps on the *Like* button on the other user tour
      Then Should see an indication of the tour being like
      And The counter should should reflect number of likes
      
### 3 @ios @android @smoke
      Scenario: Plan 3+ waypoints oneway route

      When User adds POI as a waypoint
      And User adds Highlight as a waypoint
      And User adds map point as waypoint
      Then The route is planned and details are displayed
      
### 4 @ios @android @smoke
      Scenario: Save planned route

      When User saves the route
      Then User can edit the route's name
      And The route is planned and saved
      
### 5 @ios @android @smoke
      Scenario: User cannot download a tour for offline use as Regular user

      Given User is not premium user 
      And User didn't buy region for specific tour         
      When He stores tour for the offline use
      Then Should see the Region barrier screen

