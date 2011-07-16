class Person < ActiveRecord::Base
  acts_as_multipart_form :hire_form

  validates_presence_of :name, :if => :hire_form_personal_info?
end
