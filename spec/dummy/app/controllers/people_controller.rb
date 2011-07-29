class PeopleController < ApplicationController
  acts_as_multipart_form :name => :hire_form, :parts => [:person_info, :job_info], :model => "Person", :form_route => "person_hire_form"

  def person_info
    @person = Person.find(params[:id])
  end

  def person_info_update
    @person = Person.find(params[:id])
    if @person.update_attributes(params[:person][:person])
      return {:valid => true}
    else
      return {:valid => false}
    end
  end

  def job_info
    @person = Person.find(params[:id])
  end

  def job_info_update
    @person = Person.find(params[:id])
    if @person.update_attributes(params[:person])
      return {:valid => true}
    else
      return {:valid => false}
    end
  end

  def hire_form
    #puts "stub method for the hire form"
    #@person = Person.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  def index
    @people = Person.all
    load_multipart_form_index_links(:hire_form, @people)

    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end
end
