module ActsAsMultipartForm
  module MultipartFormInModel
    
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_multipart_form(options = [])

        attr_accessor :multipart_form_controller_action
        attr_accessor :multipart_forms
        @multipart_forms = options

        include ActsAsMultipartForm::MultipartFormInModel::InstanceMethods
      end
    end

    module InstanceMethods
      def method_missing(sym, *args)
        if multipart_form_action?(sym)
          return true
        else
          super
        end
      end

      def respond_to?(sym, *args)
        if multipart_form_action?(sym)
          return true
        else
          super
        end
      end

      def multipart_form_action?(sym)
        if (!self.multipart_forms.nil? && !self.multipart_form_controller_action.nil?)
          self.multipart_forms.each do |form|
            if form.to_s + "_" + self.multipart_form_controller_action == sym.to_s
              return true
            end
          end
        end
      end
    end
  end
end
