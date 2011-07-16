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
  end

  describe "method_missing instance method" do
    it "should return true if the method is found"
    it "should call super if the method is not found"
    it "should return an error if the method is not found and it is not found in super"
  end

  describe "respond_to? instance method" do
    it "should return true if the method is found"
    it "should call super if the method is not found"
    it "should return false if the method is not found and it is not found in super"
  end

  describe "multipart_form_action? instance method" do
    it "should return true if the form_name_controller_action matches the multipart_form_controller_action"
    it "should return false if the multipart_form_controller_action does not start with the form name"
  end
end
