class PersonWithMultipleForms < ActiveRecord::Base
  acts_as_multipart_form [:hire_form, :fire_form]
  set_table_name :people
end
