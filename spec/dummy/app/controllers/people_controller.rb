class PeopleController < ApplicationController
  acts_as_multipart_form :name => :hire_form, :parts => [:person_info, :job_info], :model => "Person", :form_route => "person_hire_form"

  def person_info
  end

  def person_info_update
    @form_subject.multipart_form_controller_action = "person_info_update"
    return { :valid => @form_subject.update_attributes(params[:person]) }
  end

  def job_info
  end

  def job_info_update
    @form_subject.multipart_form_controller_action = "job_info_update"
    return { :valid => @form_subject.update_attributes(params[:person]) }
  end

  def hire_form
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
