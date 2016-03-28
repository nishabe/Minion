Given(/^the app has launched$/) do
  wait_for do
    !query("*").empty?
  end
end

#Given the app has launched
#Then I should see "MINIONS" \\ PRED-DEFINED  RUBY SCRIPT
# Given /^I am on the Welcome Screen$/ do
#     check_element_exists("textField placeholder:'Name'")
# end

    #Steps for Invalid Login
    # Then I enter "invaliduser@test.com" into input field number 1 \\ PRED-DEFINED RUBY SCRIPT
    # Then I enter "incorrect" into input field number 2 \\ PRED-DEFINED  RUBY SCRIPT
   
    # Then I touch "signin" button
Then(/^I touch "([^"]*)" button$/) do |arg1|
  touch("button marked:'#{arg1}'")
end 
    # Then I wait for 2 seconds \\ PRED-DEFINED  RUBY SCRIPT
    # Then I should see "Incorrect Credentials"  \\ PRED-DEFINED  RUBY SCRIPT
    
    # Then I touch OK
Then(/^I touch OK$/) do
  touch ("view marked: 'OK'")
end

  #Steps for Valid Login
    #Then I enter "user@test.com" into input field number 1  \\ PRED-DEFINED  RUBY SCRIPT
    #Then I enter "pass" into input field number 2  \\ PRED-DEFINED  RUBY SCRIPT
    
    #Then I touch "signin" button

    #Then I wait for 2 seconds \\ PRED-DEFINED  RUBY SCRIPT
    #Then I should see "CHECK WEATHER" \\ PRED-DEFINED  RUBY SCRIPT
