Feature: I should be able to submit data using the multipart form system

  Background:
    Given show_previous_next_links is set to true
    And show_incomplete_parts is set to true

  Scenario: Submitting on the first first page
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    When I go to the person hire_form page for that person
    And I fill in "person_person_name" with "Ethan"
    And I press "Submit"
    Then that person's information should have updated
    And I should be on the person hire_form page
    
  Scenario: Submitting on the last page
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    When I go to the person hire_form last page for that person
    And I fill in "person_name" with "Ethan"
    And I press "Submit"
    Then that person's information should have updated
    And I should be on the person show page for that person
