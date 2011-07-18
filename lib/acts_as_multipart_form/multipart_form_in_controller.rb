module ActsAsMultipartForm
  module MultipartFormInController

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_multipart_form(*args)

        mattr_accessor :multipart_forms unless self.respond_to?(:multipart_forms)
        self.multipart_forms = {} unless self.multipart_forms.is_a?(Hash)
        args.each { |arg| self.multipart_forms[arg[:name]] = arg }
        
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
