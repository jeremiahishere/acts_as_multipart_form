require "acts_as_multipart_form/railtie"
require "acts_as_multipart_form/engine"
require "acts_as_multipart_form/multipart_form_in_model"
ActiveRecord::Base.send :include, ActsAsMultipartForm::MultipartFormInModel
