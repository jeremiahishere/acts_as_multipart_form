module ActsAsMultipartForm
  module MultipartFormInController

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_multipart_form(form_name, form_parts, options = {})

        mattr_accessor :multipart_forms unless self.respond_to?(:multipart_forms)

        form_name = form_name.to_sym unless form_name.is_a?(Symbol)
        self.multipart_forms = {} unless self.multipart_forms.is_a?(Hash)
        self.multipart_forms[form_name] = { :form_parts => form_parts, :options => options }
        
        include ActsAsMultipartForm::MultipartFormInController::InstanceMethods
      end
    end
    
    module InstanceMethods
      def method_missing(sym, *args)
        puts sym
        super(sym, *args)
      end
    end
  end
end
