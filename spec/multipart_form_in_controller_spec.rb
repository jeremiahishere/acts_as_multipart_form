require 'spec_helper'

describe ActsAsMultipartForm::MultipartFormInController do
  describe "acts_as_multipart_form class method" do

    it "should include instance methods" do
      PeopleController.new.should be_a_kind_of (ActsAsMultipartForm::MultipartFormInController::InstanceMethods)
    end

    it "should setup the multipart_forms hash" do
      PeopleController.new.should respond_to :multipart_forms
    end

    it "should save the parameters to multipart_forms hash" do
      controller = PeopleController.new
      controller.multipart_forms[:hire_form][:parts].should == [:person_info, :person_info_update, :job_info, :job_info_update]
    end
  end

  describe "method_missing method" do
    before(:each) do
      @controller = PeopleController.new
    end

    it "should call the multipart form default handler any time a method is called with the same name as a multipart form" do
      @controller.stub!(:multipart_form_action?).and_return(true)
      @controller.should_receive(:multipart_form_default_handler)
      @controller.generic_multipart_form
    end

    it "should call call super otherwise" do
      @controller.stub!(:multipart_form_action?).and_return(false)
      @controller.should_not_receive(:multipart_form_handler)
      lambda { @controller.generic_multipart_form }.should raise_error(NoMethodError)
    end
  end

  describe "respond_to method" do
    before(:each) do
      @controller = PeopleController.new
    end

    it "should respond to a method with the same name as a multipart form" do
      @controller.stub!(:multipart_form_action?).and_return(true)
      @controller.should respond_to :general_multipart_form
    end

    it "should call super if the method does not have the same name as a multipart form" do
      @controller.stub!(:multipart_form_action?).and_return(false)
      @controller.should_not respond_to :general_multipart_form
    end
  end

  describe "get_next_multipart_form_part method" do
    before(:each) do
      @controller = PeopleController.new
      @controller.multipart_forms[:hire_form][:parts] = [:personal_info, :job_info]
    end

    it "should respond to get_next_multipart_form_part" do
      @controller.should respond_to :get_next_multipart_form_part
    end

    it "should return the next part" do
      @controller.get_next_multipart_form_part(:hire_form, :personal_info).should == :job_info
    end

    it "should return the current part if on the last part" do
      @controller.get_next_multipart_form_part(:hire_form, :job_info).should == :job_info
    end
  end

  describe "get_previous_multipart_form_part method" do
    before(:each) do
      @controller = PeopleController.new
      @controller.multipart_forms[:hire_form][:parts] = [:personal_info, :job_info]
    end

    it "should respond to get_previous_multipart_form_part" do
      @controller.should respond_to :get_previous_multipart_form_part
    end

    it "should return the previous part" do
      @controller.get_previous_multipart_form_part(:hire_form, :job_info).should == :personal_info
    end

    it "Should return the current part if on the first part" do
      @controller.get_previous_multipart_form_part(:hire_form, :personal_info).should == :personal_info
    end
  end

  describe "last_multipart_form_part? method" do
    before(:each) do
      @controller = PeopleController.new
      @controller.multipart_forms[:hire_form][:parts] = [:personal_info, :job_info]
    end

    it "should respond to last_multipart_form_part?" do
      @controller.should respond_to :last_multipart_form_part?
    end

    it "should return true if the parts match" do
      @controller.last_multipart_form_part?(:hire_form, :job_info).should be_true
    end

    it "should return false if the parts don't match" do
      @controller.last_multipart_form_part?(:hire_form, :personal_info).should be_false
    end
  end

  describe "first_multipart_form_part? method" do
    before(:each) do
      @controller = PeopleController.new
      @controller.multipart_forms[:hire_form][:parts] = [:personal_info, :job_info]
    end
    
    it "should respond to first_multipart_form_part?" do
      @controller.should respond_to :first_multipart_form_part?
    end

    it "should return true if the parts match" do
      @controller.first_multipart_form_part?(:hire_form, :personal_info).should be_true
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

  describe "multipart_form_handler method" do
    before(:each) do
      @controller = PeopleController.new
    end

    it "should respond to multipart_form_handler" do
      @controller.should respond_to :multipart_form_handler
    end

    it "should call the form handler" do
      @controller.should_receive(:multipart_form_handler)
      @controller.hire_form(:hire_form, :part => :personal_info)
    end

    it "should call the multipart form part method" do
      @controller.should_receive(:personal_info)
      @controller.hire_form(:hire_form, :part => :personal_info)
    end

    it "should not call the multipart form method if it is not a member of that form's parts" do
      @controller.should_not_receive(:personal_info)
      @controller.multipart_forms[:hire_form][:parts] = [:job_info, :job_info_update]
      @controller.hire_form(:hire_form, :part => :personal_info)
    end

    # needs to be rewritten because assigns is not set unless i do a get :hire_form, :params => {}
    # instead of calling it directly
    it "should save the multipart form part for the form so it is available for the view" do
      pending
      @controller.hire_form(:hire_form, :part => :personal_info)
      assigns[:multipart_form_part].should == :personal_info
    end

    it "should set the form part to the first part if no part is given in the args parameter"
    it "should create an In Progress Form object if one is not supplied"
    it "should default to the first form part if none is supplied"

    it "should render a partial fo the specified form part if it does not end in _update"

    it "should render the part after the most recently completed part if it is given a valid in_proress_form id and no part"
    it "should be able to figure when the last step is complete"
    it "should maintain the completed part state in the database"
    it "should do a bunch more things that are probably getting broken out into submethods"
  end

  describe "multipart_form_default_handler method" do

  end
end
