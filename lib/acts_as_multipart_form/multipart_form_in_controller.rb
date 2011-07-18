module ActsAsMultipartForm

  # Specify this to let the controller know how to setup the multipart forms.
  # This sets up the form action, the form parts, and any other needed options.
  # Each controller can have multiple multipart forms included on it
  #
  # The controller expects there to be an action for every form part for form_part_name and form_part_name_update
  # There are currently no checks to verify these actions but an exception will be thrown when a missing
  # action is called
  module MultipartFormInController

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Sets up the multipart form handler with the data needed to create and move through a multipart form
      # The arguments takes several important values including:
      # name: The name of the multipart form.  This creates a controller action with that name that can be used in routes and other situations
      # parts: An array of multipart form parts.  Each part must have a corresponding part_name and part_name_update method
      # other keys: Additional options for the multipart form system.
      #
      # The args parameter is an array of hashes and multiple multipart forms can be specified with a single acts_as_multipart_form call.
      # To keep the lines from being too long, acts_as_multipart_form can be called multiple times to setup the forms
      #
      # @param [Array] args An array of hashes that determines the data for a multipart form
      def acts_as_multipart_form(*args)

        mattr_accessor :multipart_forms unless self.respond_to?(:multipart_forms)
        self.multipart_forms = {} unless self.multipart_forms.is_a?(Hash)
        args.each { |arg| self.multipart_forms[arg[:name]] = arg }
        
        include ActsAsMultipartForm::MultipartFormInController::InstanceMethods
      end
    end
    
    module InstanceMethods
    
      # Overrides method missing to handle a multipart form if a method with the same name as a multipart form name is called
      # 
      # @param [Symbol] sym The name of the method
      # @param [Array] args The arguments of the method
      # @returns [?] If a multipart form action is matched, calls multipart_form_handler, otherwise calls super
      def method_missing(sym, *args)
        if multipart_form_action?(sym)
          multipart_form_handler(sym, args)
        else
          super(sym, *args)
        end
      end

      # Overrides respond_to? to return true if the symbol corresponds to a multipart form name
      # 
      # @param [Symbol] sym The name of the method
      # @param [Array] args The arguments of the method
      # @returns [True] If a multipart form action is matched returns true, otherwise calls super
      def respond_to?(sym, *args)
        if multipart_form_action?(sym)
          return true
        else
          super(sym, *args)
        end
      end

      # Determines if the symbol matches a multipart form name
      #
      # @param [Symbol] sym A name that may or may not correspond to a multipart form name
      # @return [Boolean] Returns true if the symbol matches a multipart form name
      def multipart_form_action?(sym)
        self.multipart_forms.keys.include?(sym)
      end

      # Needs comments
      def multipart_form_handler(form_name_sym, args)
        # args includes the form instance id, the current form part
        # the record this form is associated with can be found by checking the polymorphic relationship in the form instance table

        # if the form id is not set, create a new form instance record with blank set to the highest completed step
        # else
          # try to call the method from the second argument (as long as it is one of the mulipartform parts)
            # need to be careful that we don't call an arbitrary method somewhere
            # the method should set some global varaibles that are automatically (??) available to the view
          # if on a normal page
            # set the form to submit to itself with new arguments
            # render the partial with the name that corresponds to the parameter current form part
          # else if on an update page
            # the called method called at the beginning of the else block should return a boolean value
            # if it returns true validations have passed
              # redirect to the next form part, make sure submit location is set
              # on the form instance, set the highest completed step to the current action
              # if on the last page, render the view page, otherwise render the correct partial
            # else validations have failed
              # render the previous form part
              # make sure errors are set
              # make sure the url and submit actions get reset correctly
      end
    end
  end
end
