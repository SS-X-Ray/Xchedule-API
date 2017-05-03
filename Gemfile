source 'https://rubygems.org'
ruby '2.4.0'

gem 'json'
gem 'puma'
gem 'sequel'
gem 'sinatra'

gem 'hirb'
gem 'tux'

gem 'econfig'
gem 'rbnacl-libsodium'

group :development do
  gem 'rerun'
  gem 'sequel-seed'
end

group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'rack'
  gem 'rack-test'
  gem 'rake'
end

group :development, :test do
  gem 'rubocop'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end
