class PeopleController < ApplicationController
  acts_as_multipart_form :hire_form, [:person_info, :job_info]

end
