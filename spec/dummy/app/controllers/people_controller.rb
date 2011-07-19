class PeopleController < ApplicationController
  acts_as_multipart_form :name => :hire_form, :parts => [:person_info, :job_info]

  def personal_info
    puts "Stub method for the person info"
  end
end
