module MultipartForm
  class InProgressForm < ActiveRecord::Base
    belongs_to :form_subject, :polymorphic => true

    validates_presence_of :form_subject
    validates_presence_of :form_name
    validates_presence_of :last_completed_step
    validates_presence_of :completed
  end
end
