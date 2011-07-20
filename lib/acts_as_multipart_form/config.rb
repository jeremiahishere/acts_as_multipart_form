# this file was stolen from kaminari
require 'active_support/configurable'

module ActsAsMultipartForm

  def self.configure(&block)
    yield @config ||= ActsAsMultipartForm::Configuration.new
  end

  def self.config
    @config
  end

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

  configure do |config|
    config.show_completed = true
    config.show_incomplete_parts = false
    config.use_numbered_parts_on_index = true
    config.show_previous_next_links = true
  end
end
