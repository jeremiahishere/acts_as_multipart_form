require 'spec_helper'

describe ActsAsMultipartForm::MultipartFormInController do
  describe "acts_as_multipart_form class method" do
    it "should include instance methods"
    it "should error if it does not include a form_name_parts method for each multipart form"
    it "should error if it does not include a method for each part of each form"
    it "should error if it does not include a method for each update part of each form"
    
  end

  describe "multipart_form_handler method" do
    it "should have a handler method of some sort"
    it "should be able to figure out the next step"
    it "should be able to figure when the last step is complete"
    it "should maintain the completed part state in the database"
    it "should do a bunch more things that are probably getting broken out into submethods"
  end

end
