class Person < ActiveRecord::Base
  multipart_formable :forms => [:hire_form]

  attr_accessible :name

  validates_presence_of :name, :if => :hire_form_person_info_update?
end
