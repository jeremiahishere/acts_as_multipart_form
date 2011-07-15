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
  class InProgressForm < ActiveRecord::Base
    belongs_to :form_subject, :polymorphic => true

    validates_presence_of :form_subject
    validates_presence_of :form_name
    validates_presence_of :last_completed_step
    validates_presence_of :completed
  end
end
