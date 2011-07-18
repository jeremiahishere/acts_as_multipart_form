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
      controller.multipart_forms[:hire_form][:parts].should == [:person_info, :job_info]
    end
  end

  describe "method_missing method" do
    before(:each) do
      @controller = PeopleController.new
    end

    it "should call the multipart form handler any time a method is called with the same name as a multipart form" do
      @controller.stub!(:multipart_form_action?).and_return(true)
      @controller.should_receive(:multipart_form_handler)
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
    it "should have a handler method of some sort"
    it "should be able to figure out the next step"
    it "should be able to figure when the last step is complete"
    it "should maintain the completed part state in the database"
    it "should do a bunch more things that are probably getting broken out into submethods"
  end

end
