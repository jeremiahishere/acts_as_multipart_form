# this file was stolen from kaminari
require 'active_support/configurable'

module ActsAsMultipartForm

  # create new configs by passing a block with the config assignment
  def self.configure(&block)
    yield @config ||= ActsAsMultipartForm::Configuration.new
  end

  def self.config
    @config
  end

  # setup config data
  class Configuration
    include ActiveSupport::Configurable
    config_accessor :show_completed
    config_accessor :show_incomplete_parts
    config_accessor :use_numbered_parts_on_index
    config_accessor :show_previous_next_links

    def param_name
      config.param_name.respond_to?(:call) ? config.param_name.call() : config.param_name
    end
  end

  # setup default options
  # this should match the generator config that goes in the initializer file
  configure do |config|
    config.show_completed = true
    config.show_incomplete_parts = false
    config.use_numbered_parts_on_index = true
    config.show_previous_next_links = true
  end
end
