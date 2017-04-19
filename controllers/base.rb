require 'econfig'
require 'sinatra'

# configure based on environment
class XcheduleAPI < Sinatra::Base
  extend Econfig::Shortcut
  API_VER = 'api/v1'.freeze

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)

    SecureDB.setup(settings.config)
  end

  before do
    host_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  get '/?' do
    'Xchedule web API up at /api/v1'
  end
end
