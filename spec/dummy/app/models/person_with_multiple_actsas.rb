class PersonWithMultipleActsAs < ActiveRecord::Base
  multipart_formable :forms => [:hire_form]
  multipart_formable :forms => [:fire_form]
  set_table_name :people
end
