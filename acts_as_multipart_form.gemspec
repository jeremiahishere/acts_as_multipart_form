# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_as_multipart_form}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jeremiah Hemphill}, %q{Ethan Pemble}]
  s.date = %q{2011-07-28}
  s.description = %q{Multipart forms using custom routes}
  s.email = %q{jeremiah@cloudspace.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "MIT-LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "acts_as_multipart_form.gemspec",
    "app/controllers/multipart_form/in_progress_forms_controller.rb",
    "app/models/multipart_form/in_progress_form.rb",
    "app/views/multipart_form/_breadcrumb.html.erb",
    "app/views/multipart_form/_index_links.html.erb",
    "app/views/multipart_form/in_progress_form/index.html.erb",
    "app/views/multipart_form/in_progress_form/index.html.haml",
    "lib/acts_as_multipart_form.rb",
    "lib/acts_as_multipart_form/config.rb",
    "lib/acts_as_multipart_form/engine.rb",
    "lib/acts_as_multipart_form/multipart_form_in_controller.rb",
    "lib/acts_as_multipart_form/multipart_form_in_model.rb",
    "lib/acts_as_multipart_form/railtie.rb",
    "lib/generators/acts_as_multipart_form/install_generator.rb",
    "lib/generators/acts_as_multipart_form/templates/config.rb",
    "lib/generators/acts_as_multipart_form/templates/migrations/install_migration.rb.erb",
    "spec/acts_as_multipart_form_spec.rb",
    "spec/dummy/Rakefile",
    "spec/dummy/app/controllers/application_controller.rb",
    "spec/dummy/app/controllers/people_controller.rb",
    "spec/dummy/app/helpers/application_helper.rb",
    "spec/dummy/app/models/person.rb",
    "spec/dummy/app/models/person_with_multiple_actsas.rb",
    "spec/dummy/app/models/person_with_multiple_forms.rb",
    "spec/dummy/app/views/layouts/application.html.erb",
    "spec/dummy/app/views/people/_job_info.html.erb",
    "spec/dummy/app/views/people/_person_info.html.erb",
    "spec/dummy/app/views/people/hire_form.html.erb",
    "spec/dummy/app/views/people/index.html.erb",
    "spec/dummy/app/views/people/show.html.erb",
    "spec/dummy/config.ru",
    "spec/dummy/config/application.rb",
    "spec/dummy/config/boot.rb",
    "spec/dummy/config/database.yml",
    "spec/dummy/config/environment.rb",
    "spec/dummy/config/environments/development.rb",
    "spec/dummy/config/environments/production.rb",
    "spec/dummy/config/environments/test.rb",
    "spec/dummy/config/initializers/acts_as_multipart_form.rb",
    "spec/dummy/config/initializers/backtrace_silencers.rb",
    "spec/dummy/config/initializers/inflections.rb",
    "spec/dummy/config/initializers/mime_types.rb",
    "spec/dummy/config/initializers/secret_token.rb",
    "spec/dummy/config/initializers/session_store.rb",
    "spec/dummy/config/locales/en.yml",
    "spec/dummy/config/routes.rb",
    "spec/dummy/db/migrate/20110715180834_create_people.rb",
    "spec/dummy/db/migrate/20110722130249_create_multipart_form_tables.rb",
    "spec/dummy/db/schema.rb",
    "spec/dummy/features/form_breadcrumb.feature",
    "spec/dummy/features/form_submission.feature",
    "spec/dummy/features/index_links.feature",
    "spec/dummy/features/step_definitions/acts_as_multipart_form_steps.rb",
    "spec/dummy/features/step_definitions/config_steps.rb",
    "spec/dummy/features/step_definitions/web_steps.rb",
    "spec/dummy/features/support/env.rb",
    "spec/dummy/features/support/paths.rb",
    "spec/dummy/features/support/selectors.rb",
    "spec/dummy/public/404.html",
    "spec/dummy/public/422.html",
    "spec/dummy/public/500.html",
    "spec/dummy/public/favicon.ico",
    "spec/dummy/public/javascripts/application.js",
    "spec/dummy/public/javascripts/controls.js",
    "spec/dummy/public/javascripts/dragdrop.js",
    "spec/dummy/public/javascripts/effects.js",
    "spec/dummy/public/javascripts/prototype.js",
    "spec/dummy/public/javascripts/rails.js",
    "spec/dummy/public/stylesheets/.gitkeep",
    "spec/dummy/script/rails",
    "spec/in_progress_form_spec.rb",
    "spec/integration/navigation_spec.rb",
    "spec/multipart_form_in_controller_integeration_spec.rb",
    "spec/multipart_form_in_controller_spec.rb",
    "spec/multipart_form_in_model_integration_spec.rb",
    "spec/multipart_form_in_model_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/jeremiahishere/acts_as_multipart_form}
  s.licenses = [%q{MIT}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Multipart form engine on rails}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["= 3.0.7"])
      s.add_runtime_dependency(%q<capybara>, [">= 0.4.0"])
      s.add_runtime_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug19>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.6.1"])
      s.add_development_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<cucumber-rails>, [">= 0"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.3"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<ci_reporter>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["= 3.0.7"])
      s.add_dependency(%q<capybara>, [">= 0.4.0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<ruby-debug19>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.6.1"])
      s.add_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<cucumber-rails>, [">= 0"])
      s.add_dependency(%q<database_cleaner>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.3"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<ci_reporter>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["= 3.0.7"])
    s.add_dependency(%q<capybara>, [">= 0.4.0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<ruby-debug19>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.6.1"])
    s.add_dependency(%q<yard>, ["~> 0.6.0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<cucumber-rails>, [">= 0"])
    s.add_dependency(%q<database_cleaner>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.3"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<ci_reporter>, [">= 0"])
  end
end

