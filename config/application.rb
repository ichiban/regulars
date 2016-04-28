require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Regulars
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Disable generation of helpers, javascripts, css, and view specs
    config.generators do |generate|
      generate.helper false
      generate.assets false
    end

    # Disable `div#field_with_errors`
    config.action_view.field_error_proc = Proc.new { |html_tag, _| %Q(#{html_tag}).html_safe }

    # This app is for JST
    config.time_zone = 'Tokyo'
  end
end
