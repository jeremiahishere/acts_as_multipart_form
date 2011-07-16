module ActsAsMultipartForm
  module MultipartFormInController
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_multipart_form(options = [])
        puts "this probably doesn't work"
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
