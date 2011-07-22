Feature: I should be able to navigate usin ght einformation in the form breadcrumb

  Background:
    Given show_previous_next_links is set to true
    And show_incomplete_parts is set to true

  Scenario: I should be able to see all of the links if the form is complete
    Given there are no People in the system
    And a person with a complete multipart form exists
    When I go to the person hire_form page for that person
    Then I should see "Person Info"
    And I should see "Job Info"

  Scenario: I should not be able to see links to parts that are not complete if the show incomplete parts config option is set to false
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    And show_incomplete_parts is set to false
    When I go to the person hire_form page for that person
    Then I should see "Person Info"
    And I should not see "Job Info"

  Scenario: I should be able to see links to parts that are not complete if the show incomplete parts config option is set to true
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    When I go to the person hire_form page for that person
    Then I should see "Person Info"
    And I should see "Job Info"

  Scenario: I should be able to see a next link if the show_previous_next_links is set to true
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    When I go to the person hire_form page for that person
    Then I should see "Next"
    
  Scenario: I should not be able to see a next link if the show_previous_next_links is set to false
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    And show_previous_next_links is set to false
    When I go to the person hire_form page for that person
    Then I should not see "Next"
    
  Scenario: I should be able to see a previous link if the show_previous_next_links is set to true
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    When I go to the person hire_form page for that person
    Then I should see "Previous"
    
  Scenario: I should not be able to see a previous link if the show_previous_next_links is set to false
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    And show_previous_next_links is set to false
    When I go to the person hire_form page for that person
    Then I should not see "Previous"
    
  Scenario: When I click on a form part link, I should be taken to that page
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    And I am on the person hire_form page for that person
    When I follow "Job Info"
    Then I should be on the person hire_form page
    
  Scenario: When I click on a previous link, I should be taken to the previous page
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    And I am on the person hire_form page for that person
    When I follow "Previous"
    Then I should be on the person hire_form page
    
  Scenario: When I click on a next link, I should be taken to the next page
    Given there are no People in the system
    And a person with an incomplete multipart form exists
    And I am on the person hire_form page for that person
    When I follow "Next"
    Then I should be on the person hire_form page
    
