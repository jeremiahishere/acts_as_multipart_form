require "ruby-debug"
module ActsAsMultipartForm
  # Specify this to let the model know to expect multipart_form controller actions
  # Allows the model to run conditional validations by giving access to methods
  # with the form: multipart_form_name_multipart_controller_action.
  #
  # It includes support for multiple forms on a single controller by passing in an array of 
  # form symbols or a single symbol.
  module MultipartFormInModel
    
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Adds the information to the model needed to do conditional validations on the multipart forms
      # Creates the multipart_forms field to store the list of forms the model has access to
      # Creates the multipart_form_controller_action field to store the form the controller is currently on
      # This is used for validations among other things
      #
      # @param [Hash or Array] options A symobl or an array of symbols that represent multipart forms in the controller
      def acts_as_multipart_form(options = [])
        # don't allow multiple calls
        return if self.included_modules.include?(ActsAsMultipartForm::MultipartFormInModel::InstanceMethods)

        options = [ options] unless options.is_a?(Array)
        mattr_accessor :multipart_form_controller_action
        mattr_accessor :multipart_forms
        self.multipart_forms = options

        include ActsAsMultipartForm::MultipartFormInModel::InstanceMethods
      end
    end

    module InstanceMethods

      # Overrides method missing to return true if the method is of the form
      # multipart_form_name_multipart_controller_action
      #
      # If those conditions are not satisfied, called super
      #
      # @param [Symbol] sym The name of the method
      # @param [Array[ args The arguments of the method
      # @returns [Boolean] Whether or not the argument corresponds to a multipart form, otherwise super
      def method_missing(sym, *args)
        if multipart_form_action?(sym)
          return true
        else
          super
        end
      end

      # Overrides respond to to return true if the method is of the form
      # multipart_form_name_multipart_controller_action
      #
      # If those conditions are not satisfied, called super
      #
      # @param [Symbol] sym The name of the method
      # @param [Array[ args The arguments of the method
      # @returns [Boolean] Whether or not the argument corresponds to a multipart form, otherwise super
      def respond_to?(sym, *args)
        if multipart_form_action?(sym)
          return true
        else
          super
        end
      end

      # Determines if the symbol corresponds to a multipart form action
      # @param [Symbol] sym The name of the method
      # @returns [Boolean] Whether or not the argument corresponds to a multipart form, otherwise super
      def multipart_form_action?(sym)
        # the first part of this check should never fail unless someone explicitly sets the multipart_forms variable to nil
        if (!self.multipart_forms.nil? && !self.multipart_form_controller_action.nil?)
          self.multipart_forms.each do |form|
            if form.to_s + "_" + self.multipart_form_controller_action + "?" == sym.to_s
              return true
            end
          end
        end
      end
    end
  end
end
