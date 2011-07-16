require 'spec_helper'

describe Person do
  before(:each) do
    @person = Person.new 
    @person.multipart_form_controller_action = "personal_info"
  end
  
  it "should respond to hire_form_personal_info" do
    @person.respond_to?(:hire_form_personal_info?).should be_true
  end

  it "should return true for hire_form_personal_info" do
    @person.hire_form_personal_info?.should be_true
  end

  it "should call the name validation if the action is set" do
    @person.should have(1).error_on(:name)
  end

  it "should not call the name validtion if the action does not match the if actionon the validation" do
    @person.multipart_form_controller_action = "job_info"
    @person.should be_valid
  end

  it "should not call the name validtion if the action is not set" do
    @person.multipart_form_controller_action = nil
    @person.should be_valid
  end
end
