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
    it "should call the multipart form handler any time a method is called with the same name as a multipart form"
  end

  describe "respond_to method" do
    it "should return true any time a method is called with the same name as a multipart form"
  end

  describe "multipart_form_handler method" do
    it "should have a handler method of some sort"
    it "should be able to figure out the next step"
    it "should be able to figure when the last step is complete"
    it "should maintain the completed part state in the database"
    it "should do a bunch more things that are probably getting broken out into submethods"
  end

end
