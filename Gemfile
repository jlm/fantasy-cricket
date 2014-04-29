source 'https://rubygems.org'


ruby '2.0.0'

# Environment.  Locally, get stuff from ".env".  On Heroku, use heroku config:add NAME=VALUE.
gem 'dotenv-rails', :groups => [:development, :test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

#group :development do
  # Use sqlite3 as the database for Active Record
  #gem 'sqlite3', '1.3.8'
#end
# Use postgresql as the database for Active Record
gem 'pg'


# Use SCSS for stylesheets
#gem 'sass-rails', '~> 4.0.0'
#gem 'bootstrap-sass', '2.3.2.2'
gem 'bootstrap-sass-rails', '>= 3.0.2.1'
gem 'simple_form'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.1'

# For hashkey
#gem 'digest/sha1'

# Use Faker to populate some data tables
gem 'faker', '1.1.2'

# Pagination
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.10'

# Administration interface
gem 'rails-settings-cached'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use postmark to send emails
gem 'postmark-rails'

gem 'newrelic_rpm'

# We use the Heroku API just to access the app's Heroku release name
gem 'heroku-api'

# Use debugger
# gem 'debugger', group: [:development, :test]
# Add loads of debug facilities including pry-rails:
group :development, :test do
  gem 'jazz_hands'
end

group :production do
	gem 'rails_12factor'
end
