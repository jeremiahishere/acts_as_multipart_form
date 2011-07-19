require 'spec_helper'

describe PeopleController do
  it "needs to be written"
  describe "hire_form action" do
    def get_hire_form(input_params = nil)
      params = input_params || { :in_progress_form_id => 1, :multipart_form_part => :person_info }
      get :hire_form, params
    end

    it "should call the form handler" do
      pending
      @controller.should_receive(:multipart_form_handler)
      get_hire_form
    end

    it "should save the multipart form part for the form so it is available for the view" do
      pending
      get_hire_form
      assigns[:multipart_form_part].should == :person_info
    end
  end
end

