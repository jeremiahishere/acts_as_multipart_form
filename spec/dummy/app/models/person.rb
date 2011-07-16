class Person < ActiveRecord::Base
  acts_as_multipart_form [:hire_form]

  def hello
    puts "hello"
  end
end
