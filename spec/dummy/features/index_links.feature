Feature: I should be able to navigate using the information in the index links partial

  Scenario: I should see complete is the form is complete
    Given there are no People in the system
    And a person with a complete multipart form exists
    When I go to the people index page
    Then I should see "Complete"
    And I should not see "Incomplete"

  Scenario: I shold see incomplete if the form is incomplete
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    When I go to the people index page
    Then I should not see "Complete"
    And I should see "Incomplete"

  Scenario: If the form is complete, I should see all the form parts
    Given there are no People in the system
    And a person with a complete multipart form exists
    When I go to the people index page
    Then I should see "Person Info"
    And I should see "Job Info"

  Scenario: If the form is incomplete, I should not see all the form parts
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    When I go to the people index page
    Then I should see "Person Info"
    And I should not see "Job Info"

  Scenario: I should not see any form parts after the last completed step fo the in progress form object
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    When I go to the people index page
    Then I should see "Person Info"
    And I should not see "Job Info"

  Scenario: Clicking on a form part should take me to that form, that part, for that record
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    When I go to the people index page
    And I follow "Person Info"
    Then I should be on the person hire_form page

  # optional
  Scenario: I should see numbered links if the config options include numbered links
  Scenario: I should see written out links of if the config options do not include numbered links
