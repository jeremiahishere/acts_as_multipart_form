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
end
