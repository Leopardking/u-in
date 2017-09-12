require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module BookingApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.paths['app/views'] << "app/views/devise"
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    I18n.enforce_available_locales = false
    # config.assets.precompile += %w( promotions_layout.css promotions_layout.js scheduling_promotion.js angular-fullcalendar )
    # config.assets.precompile += %w( *.png *.jpeg *.jpg *.gif *.eot *.woff2 *.woff *.ttf *.svg )
    # config.autoload_paths += Dir["#{config.root}/lib/**/*"]
    # config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths += Dir[File.join(Rails.root, "lib", "ext", "*.rb")].each {|l| require l }
    # add app/assets/fonts to the asset path
    # config.assets.enabled = true
    # config.assets.paths << Rails.root.join("vendor", "assets", "fonts")
    # config.assets.paths << Rails.root.join("vendor", "assets", "images")
    # config.assets.paths << Rails.root.join("vendor", "assets", "javascripts")
    # config.assets.paths << Rails.root.join("vendor", "assets", "stylesheets")
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    #  Devise JSON
    config.to_prepare do
      DeviseController.respond_to :html, :json
    end
  end
end
