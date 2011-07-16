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

    it "should set the multipart_forms instance variable if a single symbol is given" do
      PersonWithMultipleForms.new.multipart_forms.should == [:hire_form, :fire_form]
    end

    it "should return only the first call if acts_as_multipart_form is called twice" do
      PersonWithMultipleActsAs.new.multipart_forms.should == [:hire_form]
    end
  end

  describe "method_missing instance method" do
    before(:each) do
      @person = Person.new
    end

    it "should return true if the form matches and the action matches " do
      @person.stub!(:multipart_form_action?).and_return(true)
      @person.some_multipart_form_method.should be_true
    end

    it "should return false if the method includes an existing form type but the action doesn't match" do
      pending
    end

    # I am not convinced that this covers all the test cases
    # but we are probably fine because we just need to know that super is called
    it "should call super if the multipart form name does not match an exiting form name" do
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
      @person.multipart_form_action?(:other_form_personal_info?).should be_false
    end
  end

  describe "reset_multipart_form_controller_action method" do
    before(:each) do
      @person = Person.new
      @person.multipart_form_controller_action = "action"
    end

    it "should set the controller action to nil" do
      @person.reset_multipart_form_controller_action
      @person.multipart_form_controller_action.should be_nil
    end

    it "should be called after save" do
      @person.save
      @person.multipart_form_controller_action.should be_nil
    end
  end

  describe "using_multipart_forms? method" do
    before(:each) do
      @person = Person.new
      @person.multipart_forms = [:hire_form]
      @person.multipart_form_controller_action = "action"
    end

    it "should return false if multipart forms is nil" do
      @person.multipart_forms = nil
      @person.using_multipart_forms?.should be_false
    end

    it "should return false if controller action is nil" do
      @person.multipart_form_controller_action = nil
      @person.using_multipart_forms?.should be_false
    end

    it "should return true if both are set" do
      @person.using_multipart_forms?.should be_true
    end
  end
end
