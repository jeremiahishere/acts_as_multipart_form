module MultipartForm
  # Stores information about multipart forms in progress
  # Useful when displaying information about the form especially when a user
  # stops halfway through a form and comes back to it
  #
  # form_subject is a polymorphic relationship to the model that uses the form
  #
  # form_name relates to the name of the form on the model on the line
  # acts_as_multipart_form :form_name => {:type => ...
  # @author Jeremiah Hemphill
  class InProgressForm < ::ActiveRecord::Base
    set_table_name "multipart_form_in_progress_forms"
    belongs_to :form_subject, :polymorphic => true

    attr_accessible :form_subject, :form_subject_id, :form_subject_type, :form_name, :last_completed_step, :completed

    validates_presence_of :form_subject_id
    validates_presence_of :form_subject_type
    validates_presence_of :form_name
    validates_presence_of :last_completed_step
    validates_inclusion_of :completed, :in => [true, false]
  end
end
