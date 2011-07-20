require 'rails'

require 'acts_as_multipart_form/config'

module ActsAsMultipartForm
  class Railtie < ::Rails::Railtie
    initializer 'acts_as_multipart_form' do |app|
      require "acts_as_multipart_form/multipart_form_in_model"
      ActiveRecord::Base.send :include, ActsAsMultipartForm::MultipartFormInModel
      require "acts_as_multipart_form/multipart_form_in_controller"
      ActionController::Base.send :include, ActsAsMultipartForm::MultipartFormInController
    end
  end
end
