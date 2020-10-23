require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module Furima25699
  class Application < Rails::Application
    config.load_defaults 6.0

    ## 追加
    # 《日本語化》
    config.i18n.default_locale = :ja
    # config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.yml").to_s]

    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.test_framework false
    end
  end
end