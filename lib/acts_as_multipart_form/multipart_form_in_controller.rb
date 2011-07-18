module ActsAsMultipartForm
  module MultipartFormInController

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_multipart_form(form_name, form_parts, options = {})

        mattr_accessor :multipart_forms

        form_name = form_name.to_sym unless form_name.is_a?(Symbol)
        self.multipart_forms = {} unless self.multipart_forms.is_a?(Hash)
        self.multipart_forms[form_name] = { :form_parts => form_parts, :options => options }
        
        self.multipart_forms[form_name][:form_parts].each do |part|
          unless self.respond_to?(part.to_sym)
            raise "The multipart form part #{part.to_sym} for the multipart form #{form_name} is missing"
          end
        end
        self.multipart_forms[form_name][:form_parts].each do |part|
          update_part = (part.to_s + "_update").to_sym
          unless self.respond_to?(update_part)
            raise "The multipart form part #{update_part} for the multipart form #{form_name} is missing"
          end
        end
        
        include ActsAsMultipartForm::MultipartFormInController::InstanceMethods
      end
    end
    
    module InstanceMethods
      def probably_doesnt_work
        puts "this probably doesn't work either"
      end
    end
  end
end
