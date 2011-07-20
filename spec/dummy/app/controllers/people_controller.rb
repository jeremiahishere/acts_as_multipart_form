class PeopleController < ApplicationController
  acts_as_multipart_form :name => :hire_form, :parts => [:person_info, :job_info], :model => "Person"

  def person_info
    puts "Stub method for the person info"
  end

  def person_info_update
    puts "Stub method for the person info update"
    return {:valid => true}
  end

  def job_info
    puts "stub method for the job info"
  end

  def job_info_update
    puts "Stub method for the job info update"
    return {:valid => true}
  end

  def hire_form
    puts "stub method for the hire form"
    @person = Person.create
    
    respond_to do |format|
      format.html
    end
  end
end
