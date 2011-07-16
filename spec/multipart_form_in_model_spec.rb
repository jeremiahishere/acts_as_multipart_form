require 'spec_helper'

describe ActsAsMultipartForm::MultipartFormInModel do
  describe "acts_as_multipart_form class method" do
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
