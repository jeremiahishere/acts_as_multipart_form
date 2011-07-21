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
      # model: The name of the model used to identify the multipart form.  Defaults to the singularized name of the controller.
      # form_route: The route for the form as specified in the config/routes file. Defaults to model_form_name downcased.
      # show_route: The route the form redirects to once the last part is filled out.  Defaults to the name of the model, downcased.
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
          # sets default model if it is not set
          arg[:model] = self.to_s.gsub("Controller", "").singularize unless arg.has_key?(:model)
          arg[:form_route] = (arg[:model].downcase + "_" + arg[:name].to_s) unless arg.has_key?(:form_route)
          arg[:show_route] = (arg[:model].downcase) unless arg.has_key?(:show_route)
          # copy args to fields
          self.multipart_forms[arg[:name]] = arg
          forms << arg[:name]
        end

        before_filter :multipart_form_handler, :only => forms

        include ActsAsMultipartForm::MultipartFormInController::InstanceMethods
        
      end
    end
    
    module InstanceMethods

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

      # needs comments
      def multipart_form_handler
        form_name = params[:action].to_sym
        form_subject_id = params[:id]

        form_subject = find_or_create_multipart_form_subject(form_name, form_subject_id)
        params[:id] = form_subject.id

        in_progress_form = find_or_create_multipart_in_progress_form(form_name, form_subject)

        # set the part based on the params or in progress form
        if params[:multipart_form_part]
          part = params[:multipart_form_part].to_sym
        elsif in_progress_form.last_completed_step != "none"
          part = get_next_multipart_form_part(form_name, in_progress_form.last_completed_step.to_sym)
        else
          part = self.multipart_forms[form_name][:parts].first
        end

        # call and save the part information
        if(part && self.multipart_forms[form_name][:parts].include?(part.to_sym))
          result = self.send(part)
          
          if(part.match(/_update$/))
            if(result && result[:valid])
              completed = redirect_to_next_multipart_form_part(form_name, form_subject, part)
              in_progress_form.update_attributes(:last_completed_step => part, :completed => completed)
            else
              # render the previous page but stay on this page so we keep the errors
              part = get_previous_multipart_form_part(form_name, part)
            end
          end
          # get two previous parts so the previous link works
          previous_part = get_previous_multipart_form_part(form_name, part)
          @previous_multipart_form_part = get_previous_multipart_form_part(form_name, previous_part).to_s
          # needs to be a string so that the view can read it
          @multipart_form_part = part.to_s
          @next_multipart_form_part = get_next_multipart_form_part(form_name, part).to_s
          @form_subject = form_subject
          @available_multipart_form_parts = get_available_multipart_form_parts(form_name, in_progress_form.last_completed_step)
          @multipart_form_path = (self.multipart_forms[form_name][:form_route] + "_path").to_sym
        end
      end
    
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
      

      # Given a form name and a form subject id, it creates the form subject
      # The form subject is defined by the id and the multipart form's model attribute
      # The subject is created with values and saved without validations (this might change in the future)
      #
      # @param [Symbol] form_name The name of the multipart form
      # @param [Integer] form_dubject_id The id of the form subject (could be nil)
      # @return [FormSubject] The form subject object based on the multipart form's model or nil if the id is set and not found
      def find_or_create_multipart_form_subject(form_name, form_subject_id)
        # find or create the form subject
        model = self.multipart_forms[form_name][:model]
        if form_subject_id
          form_subject = model.constantize.find(form_subject_id)
        else
          form_subject = model.constantize.new()
          form_subject.save(:validate => false)
        end
        return form_subject
      end

      # Returns the InProgressForm object when given the form name and subject
      # Creates the InPorgressForm object if it doesn't exist for the given form name/form subject pair
      #
      # @param [Symbol] form_name The name of the multipart form
      # @param [FormSubject] form_subject The multipart form's subject
      # @returns [InProgressForm] The associated or new in progress form object
      def find_or_create_multipart_in_progress_form(form_name, form_subject)
        # find or create the in progress form
        # not sure why the polymorphic relationship isn't working here
        in_progress_form = MultipartForm::InProgressForm.where(
          :form_subject_id => form_subject.id, 
          :form_subject_type => form_subject.class.to_s, 
          :form_name => form_name).first
        if !in_progress_form
          in_progress_form = MultipartForm::InProgressForm.create(
            :form_subject_id => form_subject.id, 
            :form_subject_type => form_subject.class.to_s, 
            :form_name => form_name, 
            :last_completed_step => "none", 
            :completed => false)
        end
        return in_progress_form
      end

      # Adds a redirect based on the information passed in.
      # If on the last part of the form, tries to redirect to the view page,
      # otherwise to the next form part.
      #
      # This method needs signficantly more testing (7-20-2011)
      #
      # @param [Sybmol] form_name The name of the form
      # @param [FormSubject] form_subject The subject of the form
      # @param [Symbol] part The current form part
      def redirect_to_next_multipart_form_part(form_name, form_subject, part)
        # set highest completed part to the current part4
        if(last_multipart_form_part?(form_name, part))
          # render the view page(not sure how to do this)
          redirect_to( send(self.multipart_forms[form_name][:show_route] + "_path", form_subject) )
          completed = true
        else
          # render the next page
          next_part = get_next_multipart_form_part(form_name, part)
          # maybe pass in a route
          redirect_to ( send(
            self.multipart_forms[form_name][:form_route] + "_path", 
            :id => form_subject.id.to_s, 
            :multipart_form_part => next_part.to_s))
          completed = false
        end
        return completed
      end

      # Gets the multipart form parts the user is allowed to directly link to 
      # with respect to the config information.
      #
      # If the config option show_incomplete_parts is set to false, do not return parts past the in_progress_form's last completed step
      #
      # @param [Symbol] form_name The name of the form
      # @returns [Array] An array of form part symbols with no _update parts and other config restrictions
      def get_available_multipart_form_parts(form_name, last_completed_part)
        add_parts = true
        parts = []
        # loop over the parts
        self.multipart_forms[form_name][:parts].each do |part|
          parts << part if( add_parts && !part.match(/_update$/) )
          if !ActsAsMultipartForm.config.show_incomplete_parts && part.to_s == last_completed_part.to_s
            add_parts = false 
          end
        end
        return parts
      end

    end
  end
end
