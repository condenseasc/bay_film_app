require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module BayFilmApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de


    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
    config.assets.paths << Rails.root.join('vendor', 'assets', 'templates')

    # config.paperclip_defaults = {}

  end
end

Paperclip::Attachment.default_options[:path] = "#{Rails.root}/spec/test_files/:class/:id_partition/:style.:extension"


Time::DATE_FORMATS[:today] = "today at %-l:%M%P"
# Time::DATE_FORMATS[:month_ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize} at %-l:%M%P")}
    # lambda { |time| "%B #{time.day.ordinalize} at %l-#{a = (time.min == 0) ? "" : "%M"}%P"}
Time::DATE_FORMATS[:with_month] = lambda { |time| time.strftime("%B #{time.day.ordinalize} at %-l#{a = (time.min == 0) ? "" : ":%M"}%P") }

# Time::DATE_FORMATS[:no_minutes] = lambda { |time| time.strftime("%B at %-l#{a = (time.min == 0) ? "" : "%M"}%P" )}
Time::DATE_FORMATS[:with_year] = "%Y %b %d %-l:%M%P"
Time::DATE_FORMATS[:day_id] = "%Y%m%d"


# :long_ordinal => lambda { |time| time.strftime("%B #{time.day.ordinalize}, %Y %H:%M") }