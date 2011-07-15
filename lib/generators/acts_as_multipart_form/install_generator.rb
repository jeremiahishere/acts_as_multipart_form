require 'rails/generators'
require 'rails/generators/migration'
require 'active_record'
require 'rails/generators/active_record'

module ActsAsMultipartForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))

      desc <<DESC
Description:
  Copies over migrations and config for the multipart form system.
DESC

      # Implement the required interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname) #:nodoc:
        next_migration_number = current_migration_number(dirname) + 1
        if ActiveRecord::Base.timestamped_migrations
          [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
        else
          "%.3d" % next_migration_number
        end
      end

      def copy_config_file
        copy_file "config.rb", "config/initializers/acts_as_multipart_form.rb"
      end

      def copy_migration
        migration_template "migrations/install_migration.rb", "db/migrate/create_multipart_form_tables.rb"
      end
    end
  end
end
