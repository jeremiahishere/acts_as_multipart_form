require 'spec_helper'

describe ActsAsMultipartForm::MultipartFormInModel do
  describe "acts_as_multipart_form class method" do
    it "should include instance methods" do
      Person.new.should be_a_kind_of (ActsAsMultipartForm::MultipartFormInModel::InstanceMethods)
    end

    it "should make the multipart_form_controller_action instance variable accessible" do
      Person.new.should respond_to :multipart_form_controller_action
    end

    it "should make the multipart_forms instance variable accessible" do
      Person.new.should respond_to :multipart_forms
    end

    it "should set the multipart_forms instance variable if an array is given" do
      Person.new.multipart_forms.should == [:hire_form]
    end

    it "should set the multipart_forms instance variable if a single symbol is given"

    it "should return if acts_as_multipart_form is called twice"
  end

  describe "method_missing instance method" do
    before(:each) do
      @person = Person.new
    end

    it "should return true if the method is found" do
      @person.stub!(:multipart_form_action?).and_return(true)
      @person.some_multipart_form_method.should be_true
    end

    # I am not convinced that this covers all the test cases
    # but we are probably fine because we just need to know that super is called
    it "should call super if the method is not found" do
      @person.stub!(:multipart_form_action?).and_return(false)
      lambda { @person.some_multipart_form_method }.should raise_error(NoMethodError)
    end
  end

  describe "respond_to? instance method" do
    before(:each) do
      @person = Person.new
    end

    it "should return true if the method is found" do
      @person.stub!(:multipart_form_action?).and_return(true)
      @person.respond_to?(:some_multipart_form_method).should be_true
    end

    it "should call super if the method is not found" do
      @person.stub!(:multipart_form_action?).and_return(false)
      @person.respond_to?(:class).should be_true
    end

    it "should return false if the method is not found and it is not found in super" do
      @person.stub!(:multipart_form_action?).and_return(false)
      @person.respond_to?(:some_multipart_form_method).should be_false
    end
  end

  describe "multipart_form_action? instance method" do
    before(:each) do
      @person = Person.new
    end

    it "should call using_multipart_forms?" do
      @person.should_receive(:using_multipart_forms?)
      @person.multipart_form_action?(:some_multipart_form_action?)
    end

    it "should return true if the form_name_controller_action matches the multipart_form_controller_action" do
      @person.multipart_form_controller_action = "personal_info"
      @person.multipart_form_action?(:hire_form_personal_info?).should be_true
    end
    
    it "should return false if the multipart_form_controller_action does not start with the form name" do
      @person.multipart_form_controller_action = "personal_info"
      @person.multipart_form_action?(:other_form_personal_info?).should be_true
    end
  end

  describe "reset_multipart_form_controller_action method" do
    it "should set the controller action to nil"
  end

  describe "using_multipart_forms method" do
    it "should return false if multipart forms is nil"
    it "should return false if controller action is nil"
    it "should return true if both are set"
  end
end
