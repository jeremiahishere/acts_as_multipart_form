class PersonWithMultipleActsAs < ActiveRecord::Base
  acts_as_multipart_form :hire_form
  acts_as_multipart_form :fire_form
  set_table_name :people
end
