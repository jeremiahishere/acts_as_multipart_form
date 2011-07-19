class PeopleController < ApplicationController
  acts_as_multipart_form :name => :hire_form, :parts => [:person_info, :job_info]

  def person_info
    puts "Stub method for the person info"
  end

  def job_info
    puts "stub method for the job info"
  end

  def hire_form
    puts "stub method for the hire form"
    
    #respond_to do |format|
    #  format.html
    #end
  end
end
