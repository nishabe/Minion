Feature: App launch

Scenario: Successful Applaunch
	
	#Steps to verify successful applaunch
	   #Given the app has launched
       #Then I should see "MINIONS"

	#Steps for Invalid Login
  	 Then I enter "invaliduser@test.com" into input field number 1
  	 Then I enter "incorrect" into input field number 2
  	 Then I touch "signin" button
  	 Then I wait for 2 seconds
  	 Then I should see "Incorrect Credentials"
  	 Then I touch OK

	#Steps for Valid Login
    Then I clear input field number 1
    Then I clear input field number 2
    Then I enter "user@test.com" into input field number 1
    Then I enter "pass" into input field number 2
    Then I touch "signin" button
    Then I wait for 2 seconds
    Then I should see "CHECK WEATHER"

  	#Steps for Incorrect city
  	 #Then I enter "nocity" into input field number 1
     #Then I touch "checknow" button
  	 #Then I wait for 2 seconds
     #Then I should see "There was en error. Could not load result."
  	
  	#Steps for Correct city
  	Then I clear input field number 1
  	Then I enter "Seattle" into input field number 1
    Then I touch "checknow" button
  	Then I wait for 2 seconds
    Then I should see "result"

  	#Steps for Logout
  	#Then I go back
  	#Then I wait for 2 seconds
  	#Then I touch "Sign Out" button
  	#Then I should see a "signin" button
  	#Then I wait for 2 seconds
