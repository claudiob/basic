source 'https://rubygems.org'
ruby file: '.ruby-version'

gem 'active_job-performs' # to invoke performs in Active Record
gem 'bh' # to write every form and draw every chat in Bootstrap 6
gem 'bootsnap', require: false # to reduce boot times through caching
gem 'omen' # to ask Claude about our data
gem 'openssl' # to connect to websites securely
gem 'pg' # to connect to a PostgreSQL database
gem 'propshaft' # to resolve asset_path, image_tag, javascript_include_tag, ...
gem 'puma' # to serve HTTP requests
gem 'rails', github: 'rails/rails' # to run on the all-in-one framework
gem 'recourse' # to have ready-to-go CRUD pages for admins
gem 'redis' # to support Sidekiq and RedisCacheStore
gem 'sidekiq' # to perform background jobs
gem 'turbo-rails' # to refresh a chat as its answer arrives
gem 'twi' # to text a code to a phone
gem 'yt-auth' # to sign in with Google

group :development, :test do
  gem 'brakeman', require: false # to scan for vulnerabilities
  gem 'bundler-audit', require: false # to audit gems for vulnerabilities
  gem 'debug', require: 'debug/prelude' # to invoke 'debugger'
  gem 'rubocop-rails-omakase', require: false # to run 'bin/rubocop -f github'
end

group :development do
  gem 'web-console' # to use console on exceptions pages
end

group :test do
  gem 'minitest' # to run the test suite
  gem 'simplecov', require: false # to calculate test coverage
  gem 'webmock' # to stub HTTP requests in tests
end
