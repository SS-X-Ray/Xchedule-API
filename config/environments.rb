require 'sinatra'

configure :development do
  ENV['DATABASE_URL'] = 'sqlite://db/dev.db'
end

configure :test do
  ENV['DATABASE_URL'] = 'sqlite://db/test.db'
end

configure :production do
  # Let Heroku set DATABASE_URL environment variable
end

configure do
  # Enable logging in Sinatra
  enable :logging

  require 'sequel'
  DB = Sequel.connect(ENV['DATABASE_URL'])

  # pretty output of db output in TUX
  require 'hirb'
  Hirb.enable
end
