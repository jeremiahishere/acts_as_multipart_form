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

        forms = [] 
        args.each do |arg| 
          # add the update parts
          parts = arg[:parts]
          arg[:parts] = []
          parts.each do |part|
            arg[:parts] << part
            arg[:parts] << (part.to_s + "_update").to_sym
          end
          # copy args to fields
          self.multipart_forms[arg[:name]] = arg
          forms << arg[:name]
        end

        before_filter :multipart_form_handler, :only => forms

        include ActsAsMultipartForm::MultipartFormInController::InstanceMethods
        
      end
    end
    
    module InstanceMethods
    
      # Overrides method missing to handle a multipart form if a method with the same name as a multipart form name is called
      # 
      # @param [Symbol] sym The name of the method
      # @param [Array] args The arguments of the method
      # @returns [?] If a multipart form action is matched, calls multipart_form_default_handler, otherwise calls super
      #def method_missing(sym, *args)
      #  if multipart_form_action?(sym)
      #    multipart_form_default_handler(sym, args)
      #  else
      #    super
      #  end
      #end

      # Overrides respond_to? to return true if the symbol corresponds to a multipart form name
      # 
      # @param [Symbol] sym The name of the method
      # @param [Array] args The arguments of the method
      # @returns [True] If a multipart form action is matched returns true, otherwise calls super
      #def respond_to?(sym, *args)
      #  if multipart_form_action?(sym)
      #    return true
      #  else
      #    super(sym, *args)
      #  end
      #end

      # Determines if the symbol matches a multipart form name
      #
      # @param [Symbol] sym A name that may or may not correspond to a multipart form name
      # @return [Boolean] Returns true if the symbol matches a multipart form name
      def multipart_form_action?(sym)
        self.multipart_forms.keys.include?(sym)
      end

      # Gets the next multipart form part for the form or returns the current part if it is first
      #
      # @param [Symbol] form The name of the multipart form
      # @param [Symbol] part The name of the current part
      # @returns [Symbol] The name of the next part
      def get_previous_multipart_form_part(form, part)
        part_index = self.multipart_forms[form][:parts].index(part)
        if part_index > 0
          return self.multipart_forms[form][:parts][part_index - 1]
        else
          return part
        end
      end

      # Gets the previous multipart form part for the form or returns the current part if it is first
      #
      # @param [Symbol] form The name of the multipart form
      # @param [Symbol] part The name of the current part
      # @returns [Symbol] The name of the previous part
      def get_next_multipart_form_part(form, part)
        part_index = self.multipart_forms[form][:parts].index(part)
        if part_index < self.multipart_forms[form][:parts].length - 1
          return self.multipart_forms[form][:parts][part_index + 1]
        else
          return part
        end
      end

      # Determines if the given multipart form part is the last part of the form
      #
      # @param [Symbol] form The name of the multipart form
      # @param [Symbol] part The name o the current part
      # @returns [Boolean] True if the given part matches the last part
      def last_multipart_form_part?(form, part)
        self.multipart_forms[form][:parts].last == part
      end

      # Determines if the given multipart form part is the first part of the form
      #
      # @param [Symbol] form The name of the multipart form
      # @param [Symbol] part The name o the current part
      # @returns [Boolean] True if the given part matches the first part
      def first_multipart_form_part?(form, part)
        self.multipart_forms[form][:parts].first == part
      end
      
      # sample set of multipart form actions
      # def person_info
      #   @person = Person.find(params[:id])
      # end
      #
      # def person_info_update
      #   @person = Person.find(params[:id])
      #  @person = Person.new if @person.nil?
      #
      #  save_multipart_form_data(form_instance_id, :person => @person.id)
      #  valid = @person.update_attributes(params[:person])
      #  return valid
      # end
      #
      # def job_info
      #   @job_position = JobPosition.new
      #   @job_position.person = Person.find(load_multipart_form_data(form_instance_id, :person))
      # end
      # 
      # def job_info_update
      #   valid = @job_position.update_attributes(params[:job_position])
      #   return valid
      # end
      #
      # Needs more comments
      #
      def multipart_form_handler
        form_name = params[:action]
        in_progress_form_id = params[:in_progress_form_id]

        # get the in progress form, this may need some additional data
        in_progress_form = MultipartForm::InProgressForm.find_by_id(params[:in_progress_form_id])
        if !in_progress_form
          in_progress_form = MultipartForm::InProgressForm.create(:form_name => form_name, :last_completed_step => "none")
        end

        # set the part based on the params or in progress form
        if params[:multipart_form_part]
          part = params[:multipart_form_part].to_sym
        elsif in_progress_form.last_completed_step != "none"
          part = get_next_multipart_form_part(form_name, in_progress_form.last_completed_step.to_sym)
        else
          part = self.multipart_forms[form_name][:parts].first
        end

        # load the form information
        if(part && self.multipart_forms[form_name][:parts].include?(part.to_sym))
          self.send(part)
          @multipart_form_part = part
        end
      end
      
      def multipart_form_handler_try1(form_name, args)
        # args includes the form instance id, the current form part
        part = args[:part].to_sym || get_first_multipart_form_part(form_name)
        in_progress_form_id = args[:in_progress_form_id] || nil

        # if the form id is not set, create a new form instance record with blank set to the highest completed step
        if(form_instance_id.nil? && first_multipart_form_part?(part))
          MultipartForm::InProgressForm.create(:form_subject => args[:form_subject], :form_name => form_name, :last_completed_step => "None", :completed => false)
        end
        # try to call the method from the second argument (as long as it is one of the mulipartform parts)
          # need to be careful that we don't call an arbitrary method somewhere
          # the method should set some global varaibles that are automatically (??) available to the view
        if(multipart_form_action?(part))
          data_valid = self.send(part)
        end

        # if on a normal page
          # set the form to submit to itself with new arguments
          # render the partial with the name that corresponds to the parameter current form part
        if(part.match(/_update$/))
          @multipart_form_partial = get_next_multipart_form_part(part)
          respond_to do |format|
            format.html { render :action => form_name.to_sym }
            #format.xml sometime in the future
          end

        # else if on an update page
          # the called method called at the beginning of the else block should return a boolean value
        elsif
          # if it returns true validations have passed
            # redirect to the next form part, make sure submit location is set
            # on the form instance, set the highest completed step to the current action
            # if on the last page, render the view page, otherwise render the correct partial
          if(data_valid) 
            ipf = MultipartForm::InProgressForm.find_by_id(form_instance_id)
            ipf.last_completed_step = part.to_s
            ipf.save

            
            if(last_multipart_form_part?(part))
              # render a view page
            else
              # render the next form part
            end
          # else validations have failed
            # render the previous form part
            # make sure errors are set
            # make sure the url and submit actions get reset correctly
          else
            previous_part = get_previous_multipart_form_part(form_name, part)
            #return multipart_form_handler(form_instance_id, form_name, previous_part, args + errors)
          end
        end
      end
    end
  end
end
