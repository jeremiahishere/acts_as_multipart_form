require 'rails/generators'

module ActsAsMultipartForm
  module Generators
    # Generator for copying the views into the project
    #
    # @author Jeremiah Hemphill
    class ControllersGenerator < Rails::Generators::Base

      source_root File.expand_path('../../../../app/controllers/multipart_form/', __FILE__)

      desc <<DESC
Description:
  Copies over controller and views for the multipart form system.
DESC

      desc''
      def copy_or_fetch#:nodoc:
        filename_pattern = File.join self.class.source_root, "*.rb"
        Dir.glob(filename_pattern).map { |f| File.basename f}.each do |f|
          copy_file f, "app/controllers/multipart_form/#{f}"
        end
      end
    end
  end
end



