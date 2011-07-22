class PersonWithMultipleForms < ActiveRecord::Base
  multipart_formable :forms => [:hire_form, :fire_form]
  set_table_name :people
end
