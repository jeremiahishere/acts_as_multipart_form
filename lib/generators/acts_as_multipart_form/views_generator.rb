require 'rails/generators'

module ActsAsMultipartForm
  module Generators
    # Generator for copying the views into the project
    #
    # @author Jeremiah Hemphill
    class ViewsGenerator < Rails::Generators::Base

      source_root File.expand_path('../../../../app/views/multipart_form/', __FILE__)

      desc <<DESC
Description:
  Copies over controller and views for the multipart form system.
DESC

      desc''
      def copy_or_fetch#:nodoc:
        view_directory :in_progress_form

        filename_pattern = File.join self.class.source_root, "*.erb"
        Dir.glob(filename_pattern).map { |f| File.basename f}.each do |f|
          copy_file f, "app/views/multipart_form/#{f}"
        end
      end

      private

      # copy an indivindual directory to the target project
      # @param [Symbol] name Name of the directory
      # @param [String] _target_path Location of the directory
      def view_directory(name, _target_path = nil)
        directory name.to_s, _target_path || "#{target_path}/#{name}"
      end

      # base path to put the copied views into
      def target_path
        "app/views/multipart_form"
      end
    end
  end
end


