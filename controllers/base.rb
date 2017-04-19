require 'econfig'
require 'sinatra'

# configure based on environment
class XcheduleAPI < Sinatra::Base
  API_VER = 'api/v1'.freeze

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)

    SecureDB.setup(settings.config)
  end

  get '/?' do
    'Xchedule web API up at /api/v1'
  end
end
