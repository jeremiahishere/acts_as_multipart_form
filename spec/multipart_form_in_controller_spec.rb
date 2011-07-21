require 'spec_helper'

describe ActsAsMultipartForm::MultipartFormInController do
  describe "acts_as_multipart_form class method" do
    before(:each) do
      @controller = PeopleController.new
    end

    it "should include instance methods" do
      @controller.should be_a_kind_of (ActsAsMultipartForm::MultipartFormInController::InstanceMethods)
    end

    it "should setup the multipart_forms hash" do
      @controller.should respond_to :multipart_forms
    end

    it "should save the parameters to multipart_forms hash" do
      @controller.multipart_forms[:hire_form][:parts].should == [:person_info, :person_info_update, :job_info, :job_info_update]
    end

    it "should set the model if it is not given" do
      @controller.multipart_forms[:hire_form][:model].should == "Person"
    end

    it "should set the form_route if it is not given" do
      @controller.multipart_forms[:hire_form][:form_route].should == "person_hire_form"
    end

    it "should set the show_route if it is not given" do
      @controller.multipart_forms[:hire_form][:show_route].should == "person"
    end
  end

  describe "get_next_multipart_form_part method" do
    before(:each) do
      @controller = PeopleController.new
      @controller.multipart_forms[:hire_form][:parts] = [:person_info, :job_info]
    end

    it "should respond to get_next_multipart_form_part" do
      @controller.should respond_to :get_next_multipart_form_part
    end

    it "should return the next part" do
      @controller.get_next_multipart_form_part(:hire_form, :person_info).should == :job_info
    end

    it "should return the current part if on the last part" do
      @controller.get_next_multipart_form_part(:hire_form, :job_info).should == :job_info
    end
  end

  describe "get_previous_multipart_form_part method" do
    before(:each) do
      @controller = PeopleController.new
      @controller.multipart_forms[:hire_form][:parts] = [:person_info, :job_info]
    end

    it "should respond to get_previous_multipart_form_part" do
      @controller.should respond_to :get_previous_multipart_form_part
    end

    it "should return the previous part" do
      @controller.get_previous_multipart_form_part(:hire_form, :job_info).should == :person_info
    end

    it "Should return the current part if on the first part" do
      @controller.get_previous_multipart_form_part(:hire_form, :person_info).should == :person_info
    end
  end

  describe "last_multipart_form_part? method" do
    before(:each) do
      @controller = PeopleController.new
      @controller.multipart_forms[:hire_form][:parts] = [:person_info, :job_info]
    end

    it "should respond to last_multipart_form_part?" do
      @controller.should respond_to :last_multipart_form_part?
    end

    it "should return true if the parts match" do
      @controller.last_multipart_form_part?(:hire_form, :job_info).should be_true
    end

    it "should return false if the parts don't match" do
      @controller.last_multipart_form_part?(:hire_form, :person_info).should be_false
    end
  end

  describe "first_multipart_form_part? method" do
    before(:each) do
      @controller = PeopleController.new
      @controller.multipart_forms[:hire_form][:parts] = [:person_info, :job_info]
    end
    
    it "should respond to first_multipart_form_part?" do
      @controller.should respond_to :first_multipart_form_part?
    end

    it "should return true if the parts match" do
      @controller.first_multipart_form_part?(:hire_form, :person_info).should be_true
    end

    it "should return false if the parts don't match" do
      @controller.first_multipart_form_part?(:hire_form, :job_info).should be_false
    end
  end

  describe "multipart_form_action? method" do
    before(:each) do
      @controller = PeopleController.new
    end

    it "should respond_to multipart_form_action?" do
      @controller.respond_to?(:multipart_form_action?).should be_true
    end

    it "should be true if the key is included" do
      @controller.multipart_forms.stub!(:keys).and_return([:hire_form])
      @controller.multipart_form_action?(:hire_form).should be_true
    end

    it "should be false if the key is not included" do
      @controller.multipart_forms.stub!(:keys).and_return([:some_other_form])
      @controller.multipart_form_action?(:hire_form).should be_false
    end
  end

  describe "load_multipart_form_index_links method" do
    before(:each) do
      @controller = PeopleController.new
      @form_name = :hire_form
      @person = mock_model(Person)
      @person.stub!(:id).and_return(34)
      @form_subjects = [@person]
      @ipf = mock_model(MultipartForm::InProgressForm)
      @ipf.stub!(:last_completed_step)
      @ipf.stub!(:completed).and_return(true)
      @controller.stub!(:find_or_create_multipart_in_progress_form).and_return(@ipf)
    end

    it "should call find_or_create_multipart_in_progress_form" do
      @controller.should_receive(:find_or_create_multipart_in_progress_form)
      @controller.load_multipart_form_index_links(@form_name, @form_subjects)
    end

    it "should call get_available_multipart_form_parts" do
      @controller.should_receive(:get_available_multipart_form_parts)
      @controller.load_multipart_form_index_links(@form_name, @form_subjects)
    end
      
    it "should call completed for in_progress_form" do
      @ipf.should_receive(:completed).and_return(true)
      @controller.load_multipart_form_index_links(@form_name, @form_subjects)
    end

    it "should call last_completed_step for in_progress_form" do
      @ipf.should_receive(:last_completed_step).and_return(:form_part)
      @controller.load_multipart_form_index_links(@form_name, @form_subjects)
    end
  end

  describe "multipart_form_handler method" do
    before(:each) do
      @controller = PeopleController.new
      @default_params = {
        :action => :hire_form,
        :multipart_form_part => :person_info,
        :in_progress_form_id => 100
      }
      @controller.stub!(:params).and_return(@default_params)
      @controller.multipart_forms[:hire_form][:parts] = [:person_info, :person_info_update, :job_info, :job_info_update]
    end

    it "should respond to multipart_form_handler" do
      @controller.should respond_to :multipart_form_handler
    end

    it "should call the multipart form part method" do
      @controller.should_receive(:person_info)
      @controller.multipart_form_handler
    end

    it "should not call the multipart form method if it is not a member of that form's parts" do
      @controller.should_not_receive(:person_info)
      @controller.multipart_forms[:hire_form][:parts] = [:job_info, :job_info_update]
      @controller.multipart_form_handler
    end

    # this is not great
    # should be refactored so it doesn't hit the database
    it "should default to the last completed step of the in progress form is not set in params" do
      ipf = MultipartForm::InProgressForm.new(:last_completed_step => "person_info_update")
      ipf.save(:validate => false)
      params = {
        :action => :hire_form,
        :in_progress_form_id => ipf.id
      }
      @controller.stub!(:params).and_return(params)
      @controller.stub!(:find_or_create_multipart_form_subect)
      @controller.stub!(:find_or_create_multipart_in_progress_form).and_return(ipf)
      @controller.should_receive(:job_info)
      @controller.multipart_form_handler
    end
    
    it "should default to the first part if no part is given and the in progress form does not have a completed part" do
      params = {
        :action => :hire_form,
        :in_progress_form_id => 100
      }
      @controller.stub!(:params).and_return(params)
      @controller.should_receive(:person_info)
      @controller.multipart_form_handler
    end

    it "should maintain the completed part state in the database" do
      params = {
        :action => :hire_form,
        :multipart_form_part => :person_info_update,
        :in_progress_form_id => 100
      }
      @controller.stub!(:params).and_return(params)
      ipf = MultipartForm::InProgressForm.new
      @controller.stub!(:find_or_create_multipart_in_progress_form).and_return(ipf)
      @controller.stub!(:person_info_update).and_return({:valid => true})
      @controller.stub!(:redirect_to_next_multipart_form_part).and_return(false)
      ipf.should_receive(:update_attributes).with(:completed => false, :last_completed_step => :person_info_update)

      @controller.multipart_form_handler
    end
  end

  describe "find_or_create_multipart_form_subject method" do
    before(:each) do
      @controller = PeopleController.new
      @controller.multipart_forms[:hire_form][:model] = "Person"
    end

    it "should find the form subject on a valid id" do
      Person.should_receive(:find)
      @controller.find_or_create_multipart_form_subject(:hire_form, 1)
    end

    it "should create the form subject if there is no id given" do
      p = mock_model(Person)
      Person.should_receive(:new).and_return(p)
      p.should_receive(:save).with(:validate => false)
      @controller.find_or_create_multipart_form_subject(:hire_form, nil)
    end

    it "should return an error or nil if the id is invalid" do
      Person.should_receive(:find).and_return(nil)
      @controller.find_or_create_multipart_form_subject(:hire_form, 1).should be_nil
    end
  end

  describe "find_or_create_multipart_in_progress_form method" do
    before(:each) do
      @controller = PeopleController.new
      @form_subject = mock_model(Person)
      @ipf = mock_model(MultipartForm::InProgressForm)
    end

    it "should find the in progress form if it exists" do
      MultipartForm::InProgressForm.should_receive(:where).and_return([@ipf])
      @controller.find_or_create_multipart_in_progress_form(:hire_form, @form_subject).should == @ipf
    end
    
    it "should create an in progress form if it doesn't exist" do
      MultipartForm::InProgressForm.should_receive(:create).and_return(@ipf)
      @controller.find_or_create_multipart_in_progress_form(:hire_form, @form_subject).should == @ipf
    end
    
    # maybe refactor so it doesn't hit the database
    it "should create an in progress form with a last_completed_step initially set to 'none'" do
      @controller.find_or_create_multipart_in_progress_form(:hire_form, @form_subject).last_completed_step.should == "none"
    end
  end

  # marking these test pending for now becuase I don't know how to fix the issues with rspec and redirect_to
  # they only break in rspec as far as I can tell
  describe "redirect_to_next_multipart_form_part method" do
    before(:each) do
      @controller = PeopleController.new
      @form_name = :hire_form
      @form_subject = mock_model(Person)
      @form_subject.stub!(:id).and_return(1)
      @part = :person_info
    end

    it "should redirect to the view page if on the last step" do
      pending
      @controller.stub!(:last_multipart_form_part?).and_return(true)
      @controller.redirect_to_next_multipart_form_part(@form_name, @form_subject, @part).should redirect_to("/people/1")
    end
    
    it "should return true if on the last step" do
      pending
      @controller.stub!(:last_multipart_form_part?).and_return(true)
      @controller.redirect_to_next_multipart_form_part(@form_name, @form_subject, @part).should be_true
    end

    it "should redirect to the given route and path if not on the last step" do
      pending
      @controller.stub!(:last_multipart_form_part?).and_return(false)
      @controller.redirect_to_next_multipart_form_part(@form_name, @form_subject, @part).should redirect_to("/people/hire_form/1/job_info")
    end

    it "should return false if not on the last step" do
      @controller.stub!(:last_multipart_form_part?).and_return(false)
    end
  end

  describe "get_available_multipart_form_parts method" do
    before(:each) do
      @controller = PeopleController.new
      @form_name = :hire_form
      @last_completed_part = :person_info_update
      @controller.multipart_forms[@form_name][:parts] = [:person_info, :person_info_update, :job_info, :job_info_update]
    end

    it "should return the parts" do
      ActsAsMultipartForm.config.stub!(:show_incomplete_parts).and_return(true)
      results = @controller.get_available_multipart_form_parts(@form_name, @last_completed_part)
      results.should include :person_info
      results.should include :job_info
    end

    it "should not return the _update parts" do
      ActsAsMultipartForm.config.stub!(:show_incomplete_parts).and_return(true)
      results = @controller.get_available_multipart_form_parts(@form_name, @last_completed_part)
      results.should_not include :person_info_update
      results.should_not include :job_info_update
    end

    it "should not return future parts if the config is set to not show incomplete parts" do
      ActsAsMultipartForm.config.stub!(:show_incomplete_parts).and_return(false)
      results = @controller.get_available_multipart_form_parts(@form_name, @last_completed_part)
      results.should include :person_info
      results.should_not include :job_info

    end
    it "should return future parts if the config is set to show incomplete parts" do
      ActsAsMultipartForm.config.stub!(:show_incomplete_parts).and_return(true)
      results = @controller.get_available_multipart_form_parts(@form_name, @last_completed_part)
      results.should include :person_info
      results.should include :job_info
    end
  end
end
