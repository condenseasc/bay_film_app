source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'

group :production, :development, :test do
  gem 'pg', '~> 0.17.0'
end

gem 'rails', '4.1.0'
gem 'angularjs-rails', '~> 1.2.7'
gem 'paperclip', '~> 4.1.1'

group :development, :test do
  gem 'rspec-rails', '~> 3.0.2'
	gem 'guard-rspec', '~> 4.3.1'
	gem 'guard-spork', '~> 1.5.1'
	gem 'spork-rails', '~> 4.0.0'
	gem 'childprocess', '~>0.3.9'
end


group :test do
	gem 'selenium-webdriver', '~> 2.0'
	gem 'capybara', '~> 2.4.1'
	gem 'factory_girl_rails'
	gem 'factory_girl_json'
	gem 'database_cleaner', github: 'bmabey/database_cleaner'
  gem 'libnotify' if /linux/ =~ RUBY_PLATFORM
  gem 'growl' if /darwin/ =~ RUBY_PLATFORM
	gem 'jasmine'
	gem 'faker', '~> 1.2.0'

end

gem 'bootstrap-sass', '~> 3.0.3.0'
gem "sass-rails", "~> 4.0.3"
gem 'uglifier', '>= 1.3.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'active_model_serializers'
gem 'phashion'

gem 'nokogiri', '~> 1.6.1'
gem 'mechanize', '~> 2.6.0'
gem 'bower-rails'


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
group :development do
  gem 'capistrano'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
end

# Use debugger
# gem 'debugger', group: [:development, :test]
