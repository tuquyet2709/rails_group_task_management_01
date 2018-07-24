require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    config.load_defaults 5.1
    I18n.available_locales = [:en, :vi]
    I18n.default_locale = :en
  end
end
