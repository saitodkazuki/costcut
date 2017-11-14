require_relative 'boot'
require 'rails/all'
Bundler.require(*Rails.groups)

module CostTokyo
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework nil
      g.assets         false
      g.helper         false
      g.stylesheets    false
    end

    # config.i18n.available_locales = %i(ja en)
    config.i18n.available_locales = %i(en)
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :en
    config.i18n.load_path += Dir[Rails.root.join('app', 'locales', '*.{rb,yml}').to_s]

    config.eager_load_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib', 'autoload')
  end
end
