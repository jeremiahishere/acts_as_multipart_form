class PeopleController < ApplicationController
  acts_as_multipart_form :hire_form, [:person_info, :job_info]

  def person_info
    puts "Stub method for the person info"
  end
end
