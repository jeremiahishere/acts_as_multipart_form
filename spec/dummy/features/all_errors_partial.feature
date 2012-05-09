Feature: I should be able to see error messages

  Scenario: Errors on the person info page
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    When I go to the person hire_form page for that person
    And I fill in "person_name" with ""
    And I press "Submit"
    Then I should see "1 error prohibited this form from being saved:"
    And I should see "Person: Name can't be blank"
    
  Scenario: No errors on the person info page
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    When I go to the person hire_form page for that person
    And I fill in "person_name" with "Jeremiah"
    And I press "Submit"
    Then I should not see "0 errors prohibited this form from being saved:"
    And I should not see "Person: Name can't be blank"
