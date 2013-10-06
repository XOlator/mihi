if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end


source 'https://rubygems.org'


# CORE
gem 'rails',                      '4.0.0'
gem 'mysql2',                     '0.3.13'
gem 'multi_json',                 '1.7.9'

gem 'sass-rails', '~> 4.0.0'
# gem 'uglifier', '>= 1.3.0'
# gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby


# BASICS
group :development, :staging, :test, :production do
  # Core compontents
  gem 'mysql2',                     '0.3.13'    # MySQL adapter
  gem 'authlogic',                  '3.3.0'     # Userauth
  gem 'addressable',                '2.3.5'     # Better URI parsing
  gem 'haml',                       '4.0.3'     # Templating
  gem 'will_paginate',              '3.0.4'     # Pagination
  gem 'jquery-rails',               '3.0.4'     # Rails jQuery integration
  # gem 'jquery-ui-rails',            '4.0.4'     # jQuery UI
  gem 'friendly_id',                '5.0.0.rc2',# Nice URL slugs
    git: 'https://github.com/norman/friendly_id.git', branch: '5.0-stable'
  gem 'paperclip',                  '3.5.1'     # File/Photo handling
  gem 'countries',                  '0.9.2'     # Countries list
  gem 'date_validator',             '0.7.0'     # Nicer date validation

  # API Integrations
  gem 'aws-sdk',                    '1.17.0'

  # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
  # gem 'turbolinks',                 '1.3.0'

  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
  # gem 'jbuilder', '~> 1.2'

  # DISPLAY
  gem 'font-awesome-rails',           '3.2.1.3'

  # JOBS QUEUE
  # gem 'daemons',                    '1.1.9'     # Ruby script wrapper for delayed_job
  # gem 'delayed_job',                '4.0.0'     # Job queue lib
  # gem 'delayed_job_active_record',  '4.0.0'     # delayed_job for ActiveRecord
end



# # DOCUMENTATION
# group :doc do
#   # bundle exec rake doc:rails generates the API under doc/api.
#   gem 'sdoc', require: false
# end
# 
# 
# DEVELOPMENT
group :development do
  gem 'capistrano',                 '2.15.5'    # Cap is only run in dev on local side...
  gem 'rvm-capistrano',             '1.5.0'
  gem 'cap-recipes',                '0.3.39'
  gem 'capistrano-ext',             '1.2.1'
  gem 'unicorn',                    '4.6.3'
  # gem 'annotate',                   '2.5.0'     # Pretty details in models
  gem 'quiet_assets',               '1.0.2'
  # gem 'better_errors',              '0.9.0'
  # gem 'binding_of_caller',          '0.7.2'
end


# DEVELOPMENT & TESTING
group :development, :test do
  gem 'rspec-rails',                '2.14.0'
  gem 'factory_girl_rails',         '4.2.1'
  gem 'newrelic_rpm',               '3.6.6.147'
  gem 'sqlite3',                    '1.3.8'
end


# TESTING
group :test do
  gem 'rspec',                      '2.14.1'
  gem 'spork',                      '0.9.2'
  gem 'turn',                       '0.9.6',    require: false
  # gem 'coveralls',                  '', require: false
  gem 'simplecov',                  '0.7.1',    require: false
  gem 'timecop',                    '0.6.3'
  gem 'webmock',                    '1.13.0'
end


# MONITORING SERVICES
group :development, :staging, :production do
  gem 'airbrake',                   '3.1.14'
  # gem 'errplane',                   '0.6.6'
end