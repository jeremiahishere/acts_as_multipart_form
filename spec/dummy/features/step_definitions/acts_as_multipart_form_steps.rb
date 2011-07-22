Given /^there are no People in the system$/ do
  Person.all.each do |p|
    p.destroy
  end
end

Given /^a person with a complete multipart form exists$/ do
  p = Person.create(:name => "Jeremiah")
  ipf = MultipartForm::InProgressForm.create(
    :form_subject_type => "Person", 
    :form_subject_id => p.id, 
    :form_name => "hire_form", 
    :completed => true, 
    :last_completed_step => "job_info_update")
end

Given /^a person with an incomplete multipart form exists$/ do
  p = Person.create(:name => "Jeremiah")
  ipf = MultipartForm::InProgressForm.create(
    :form_subject_type => "Person", 
    :form_subject_id => p.id, 
    :form_name => "hire_form", 
    :completed => false, 
    :last_completed_step => "person_info_update")
end

Then(/^that person's information should have updated$/) do
  p = Person.last
  p.name.should == "Ethan"
end
