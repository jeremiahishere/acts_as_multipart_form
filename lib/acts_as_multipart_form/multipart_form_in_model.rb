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
      # @param [Hash] options A hash of symbols that represent multipart forms in the controller
      def multipart_formable(*args)

        mattr_accessor :multipart_form_controller_action unless self.respond_to?(:multipart_form_controller_action)
        mattr_accessor :multipart_forms unless self.respond_to?(:multipart_forms)
        self.multipart_forms = [] unless self.multipart_forms.is_a?(Array)
        self.multipart_forms |= args[0][:forms]
        
        # after save, the current controller action should not be set
        after_save :reset_multipart_form_controller_action

        include ActsAsMultipartForm::MultipartFormInModel::InstanceMethods
      end
    end

    module InstanceMethods

      # Sets the controller action to nil
      # When we are not performing a save (or other action from a controller), 
      # the controller action should not be set
      def reset_multipart_form_controller_action
        self.multipart_form_controller_action = nil
      end

      # Determines whether multipart form controller is in use
      # @returns [Boolean] True if both the multipart_forms and multipart_form_controller fields are set
      def using_multipart_forms?
        return(!self.multipart_forms.nil? && !self.multipart_form_controller_action.nil?)
      end

      # Overrides method missing to return true if the method is of the form
      # multipart_form_name_multipart_controller_action
      #
      # If those conditions are not satisfied, called super
      #
      # @param [Symbol] sym The name of the method
      # @param [Array[ args The arguments of the method
      # @returns [Boolean] Whether or not the argument corresponds to a multipart form, otherwise super
      def method_missing(sym, *args)
        if multipart_form_method?(sym)
          return multipart_form_controller_action?(sym)
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
        if multipart_form_method?(sym)
          return multipart_form_controller_action?(sym)
        else
          super
        end
      end

      # determines whether the given method should be handled by the multipart form method handler
      # based on whether it starts with the form name followed by an underscore
      #
      # @param [Symbol] sym Method to check
      # @return [Boolean] Whether or not the symbol starts with one of the multipart forms
      def multipart_form_method?(sym)
        if self.multipart_forms
          return self.multipart_forms.select {|form| sym.to_s =~ /^#{form}_/}.length > 0  
        end
        return false
      end

      # Determines if the symbol corresponds to a multipart form action
      # @param [Symbol] sym The name of the method
      # @returns [Boolean] Whether or not the argument corresponds to a multipart form, otherwise super
      def multipart_form_controller_action?(sym)
        if using_multipart_forms?
          return self.multipart_forms.select {|form| form.to_s + "_" + self.multipart_form_controller_action + "?" == sym.to_s}.length > 0  
        end
        return false
      end
    end
  end
end
