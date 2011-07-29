class Person < ActiveRecord::Base
  multipart_formable :forms => [:hire_form]

  #validates_presence_of :name, :if => :hire_form_personal_info?
  validates_presence_of :name
end
