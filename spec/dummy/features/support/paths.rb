module NavigationHelpers

  def path_to(page_name)
    case page_name

    when /^the people index page$/
      "/people"
    when /^the person hire_form page$/
      "/people/hire_form"
    when /^the person hire_form first page for that person$/
      "/people/hire_form/" + Person.last.id.to_s + "/person_info"
    when /^the person hire_form last page for that person$/
      "/people/hire_form/" + Person.last.id.to_s + "/job_info"
    when /^the person show page for that person$/
      "/people/" + Person.last.id.to_s


    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)

