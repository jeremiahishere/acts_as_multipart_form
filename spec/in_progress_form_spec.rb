require 'spec_helper'

describe MultipartForm::InProgressForm do
  describe "validations" do
    before(:each) do
      @ip_form = MultipartForm::InProgressForm.new
      @person = mock_model(Person)
      @person.stub!(:model).and_return("Person")
      @person.stub!(:id).and_return(1)

      form_name = :person_form.to_s

      valid_attributes = {
        :form_subject => @person,
        :forn_name => "hire_form",
        :last_completed_step => "personal_info",
        :completed => "false"
      }

    end

    it "should be valid" do
      @ip_form.attributes = valid_attributes
      @ip_form.should be_valid
    end

    it "should require a form subject" do
      @ip_form.should have(1).error_on(:form_subject)
    end

    it "should require a form name" do
      @ip_form.should have(1).error_on(:form_name)
    end

    it "should require a last completed step" do
      @ip_form.should have(1).error_on(:last_completed_step)
    end

    it "should require completed" do
      @ip_form.should have(1).error_on(:completed)
    end
  end
end
